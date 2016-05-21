module Components.Card exposing (viewCard)

import Html exposing (Html)
import Html.Attributes exposing (style)
import Model exposing (Model)
import Update exposing (Msg)
import Svg exposing (svg, rect, text', text, foreignObject)
import Svg.Attributes exposing (width, height, viewBox, x, y, rx, ry, fill, fontSize, fontFamily)
import Components.Logo exposing (viewLogo)
import Helpers.Misc as Helper exposing (printNumber, rightPad, leftPad)
import String


viewCard : Model Msg -> Html Msg
viewCard model =
    let
        number =
            printNumber model.options.maxNumberLength
                model.options.blankChar
                model.number.value

        blankName =
            "YOUR NAME"

        name =
            model.name.value
                |> Maybe.map String.toUpper
                |> Maybe.withDefault ""
                |> (\name ->
                        if String.isEmpty name then
                            blankName
                        else
                            name
                   )

        blankMonth =
            List.repeat 2 model.options.blankChar
                |> String.fromList

        expirationMonth =
            model.expirationMonth.value
                |> Maybe.map toString
                |> Maybe.withDefault ""
                |> (\str ->
                        if String.isEmpty str then
                            blankMonth
                        else
                            leftPad '0' 2 str
                   )

        expirationYear =
            model.expirationYear.value
                |> Maybe.map toString
                |> Maybe.withDefault ""
                |> rightPad model.options.blankChar 4

        cardStyle =
            model.cardInfo.cardStyle
    in
        svg [ width "350", height "220", viewBox "0 0 350 220", fontFamily "monospace" ]
            [ rect (List.append [ x "0", y "0", width "350", height "220", rx "5", ry "5" ] cardStyle.background.attributes) cardStyle.background.svg
            , viewLogo model
            , text' [ x "40", y "110", fontSize "22", fill cardStyle.textColor ] [ text number ]
            , foreignObject [ x "40", y "160", fontSize "16", width "170", fill cardStyle.textColor ]
                [ Html.p [ style [ ( "color", cardStyle.textColor ) ] ]
                    [ Html.text name ]
                ]
            , text' [ x "250", y "160", fontSize "10", fill cardStyle.lightTextColor ] [ text "MONTH/YEAR" ]
            , text' [ x "215", y "170", fontSize "8", fill cardStyle.lightTextColor ] [ text "valid" ]
            , text' [ x "220", y "180", fontSize "8", fill cardStyle.lightTextColor ] [ text "thru" ]
            , text' [ x "250", y "180", fontSize "14", fill cardStyle.textColor ] [ text (expirationMonth ++ "/" ++ expirationYear) ]
            ]
