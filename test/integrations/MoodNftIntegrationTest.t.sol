// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftTest is Test {
    MoodNft moodNft;
    DeployMoodNft deployer;

    string public constant HAPPY_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIxMDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIgLz4KICAgIDxnIGNsYXNzPSJleWVzIj4KICAgICAgICA8Y2lyY2xlIGN4PSI2MSIgY3k9IjgyIiByPSIxMiIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiIC8+CiAgICA8L2c+CiAgICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7IiAvPgo8L3N2Zz4=";
    string public constant SAD_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/Pgo8c3ZnIHdpZHRoPSIxMDI0cHgiIGhlaWdodD0iMTAyNHB4IiB2aWV3Qm94PSIwIDAgMTAyNCAxMDI0IiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogICAgPHBhdGggZmlsbD0iIzMzMyIKICAgICAgICBkPSJNNTEyIDY0QzI2NC42IDY0IDY0IDI2NC42IDY0IDUxMnMyMDAuNiA0NDggNDQ4IDQ0OCA0NDgtMjAwLjYgNDQ4LTQ0OFM3NTkuNCA2NCA1MTIgNjR6bTAgODIwYy0yMDUuNCAwLTM3Mi0xNjYuNi0zNzItMzcyczE2Ni42LTM3MiAzNzItMzcyIDM3MiAxNjYuNiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzIgMzcyeiIgLz4KICAgIDxwYXRoIGZpbGw9IiNFNkU2RTYiCiAgICAgICAgZD0iTTUxMiAxNDBjLTIwNS40IDAtMzcyIDE2Ni42LTM3MiAzNzJzMTY2LjYgMzcyIDM3MiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzItMTY2LjYtMzcyLTM3Mi0zNzJ6TTI4OCA0MjFhNDguMDEgNDguMDEgMCAwIDEgOTYgMCA0OC4wMSA0OC4wMSAwIDAgMS05NiAwem0zNzYgMjcyaC00OC4xYy00LjIgMC03LjgtMy4yLTguMS03LjRDNjA0IDYzNi4xIDU2Mi41IDU5NyA1MTIgNTk3cy05Mi4xIDM5LjEtOTUuOCA4OC42Yy0uMyA0LjItMy45IDcuNC04LjEgNy40SDM2MGE4IDggMCAwIDEtOC04LjRjNC40LTg0LjMgNzQuNS0xNTEuNiAxNjAtMTUxLjZzMTU1LjYgNjcuMyAxNjAgMTUxLjZhOCA4IDAgMCAxLTggOC40em0yNC0yMjRhNDguMDEgNDguMDEgMCAwIDEgMC05NiA0OC4wMSA0OC4wMSAwIDAgMSAwIDk2eiIgLz4KICAgIDxwYXRoIGZpbGw9IiMzMzMiCiAgICAgICAgZD0iTTI4OCA0MjFhNDggNDggMCAxIDAgOTYgMCA0OCA0OCAwIDEgMC05NiAwem0yMjQgMTEyYy04NS41IDAtMTU1LjYgNjcuMy0xNjAgMTUxLjZhOCA4IDAgMCAwIDggOC40aDQ4LjFjNC4yIDAgNy44LTMuMiA4LjEtNy40IDMuNy00OS41IDQ1LjMtODguNiA5NS44LTg4LjZzOTIgMzkuMSA5NS44IDg4LjZjLjMgNC4yIDMuOSA3LjQgOC4xIDcuNEg2NjRhOCA4IDAgMCAwIDgtOC40QzY2Ny42IDYwMC4zIDU5Ny41IDUzMyA1MTIgNTMzem0xMjgtMTEyYTQ4IDQ4IDAgMSAwIDk2IDAgNDggNDggMCAxIDAtOTYgMHoiIC8+Cjwvc3ZnPg==";
    string public constant SAD_MOOD_URI =
        "data:application/json;base64,eyJuYW1lIjoiTW9vZCIsICJkZXNjcmlwdGlvbiI6IkFuIE5GVCB0aGF0IHJlZmxlY3RzIHRoZSBtb29kIG9mIHRoZSBvd25lciwgMTAwJSBvbiBDaGFpbiEiLCAiYXR0cmlidXRlcyI6IFt7InRyYWl0X3R5cGUiOiAibW9vZGluZXNzIiwgInZhbHVlIjogMTAwfV0sICJpbWFnZSI6ImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEQ5NGJXd2dkbVZ5YzJsdmJqMGlNUzR3SWlCemRHRnVaR0ZzYjI1bFBTSnVieUkvUGdvOGMzWm5JSGRwWkhSb1BTSXhNREkwY0hnaUlHaGxhV2RvZEQwaU1UQXlOSEI0SWlCMmFXVjNRbTk0UFNJd0lEQWdNVEF5TkNBeE1ESTBJaUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lQZ29nSUNBZ1BIQmhkR2dnWm1sc2JEMGlJek16TXlJS0lDQWdJQ0FnSUNCa1BTSk5OVEV5SURZMFF6STJOQzQySURZMElEWTBJREkyTkM0MklEWTBJRFV4TW5NeU1EQXVOaUEwTkRnZ05EUTRJRFEwT0NBME5EZ3RNakF3TGpZZ05EUTRMVFEwT0ZNM05Ua3VOQ0EyTkNBMU1USWdOalI2YlRBZ09ESXdZeTB5TURVdU5DQXdMVE0zTWkweE5qWXVOaTB6TnpJdE16Y3ljekUyTmk0MkxUTTNNaUF6TnpJdE16Y3lJRE0zTWlBeE5qWXVOaUF6TnpJZ016Y3lMVEUyTmk0MklETTNNaTB6TnpJZ016Y3llaUlnTHo0S0lDQWdJRHh3WVhSb0lHWnBiR3c5SWlORk5rVTJSVFlpQ2lBZ0lDQWdJQ0FnWkQwaVRUVXhNaUF4TkRCakxUSXdOUzQwSURBdE16Y3lJREUyTmk0MkxUTTNNaUF6TnpKek1UWTJMallnTXpjeUlETTNNaUF6TnpJZ016Y3lMVEUyTmk0MklETTNNaTB6TnpJdE1UWTJMall0TXpjeUxUTTNNaTB6TnpKNlRUSTRPQ0EwTWpGaE5EZ3VNREVnTkRndU1ERWdNQ0F3SURFZ09UWWdNQ0EwT0M0d01TQTBPQzR3TVNBd0lEQWdNUzA1TmlBd2VtMHpOellnTWpjeWFDMDBPQzR4WXkwMExqSWdNQzAzTGpndE15NHlMVGd1TVMwM0xqUkROakEwSURZek5pNHhJRFUyTWk0MUlEVTVOeUExTVRJZ05UazNjeTA1TWk0eElETTVMakV0T1RVdU9DQTRPQzQyWXkwdU15QTBMakl0TXk0NUlEY3VOQzA0TGpFZ055NDBTRE0yTUdFNElEZ2dNQ0F3SURFdE9DMDRMalJqTkM0MExUZzBMak1nTnpRdU5TMHhOVEV1TmlBeE5qQXRNVFV4TGpaek1UVTFMallnTmpjdU15QXhOakFnTVRVeExqWmhPQ0E0SURBZ01DQXhMVGdnT0M0MGVtMHlOQzB5TWpSaE5EZ3VNREVnTkRndU1ERWdNQ0F3SURFZ01DMDVOaUEwT0M0d01TQTBPQzR3TVNBd0lEQWdNU0F3SURrMmVpSWdMejRLSUNBZ0lEeHdZWFJvSUdacGJHdzlJaU16TXpNaUNpQWdJQ0FnSUNBZ1pEMGlUVEk0T0NBME1qRmhORGdnTkRnZ01DQXhJREFnT1RZZ01DQTBPQ0EwT0NBd0lERWdNQzA1TmlBd2VtMHlNalFnTVRFeVl5MDROUzQxSURBdE1UVTFMallnTmpjdU15MHhOakFnTVRVeExqWmhPQ0E0SURBZ01DQXdJRGdnT0M0MGFEUTRMakZqTkM0eUlEQWdOeTQ0TFRNdU1pQTRMakV0Tnk0MElETXVOeTAwT1M0MUlEUTFMak10T0RndU5pQTVOUzQ0TFRnNExqWnpPVElnTXprdU1TQTVOUzQ0SURnNExqWmpMak1nTkM0eUlETXVPU0EzTGpRZ09DNHhJRGN1TkVnMk5qUmhPQ0E0SURBZ01DQXdJRGd0T0M0MFF6WTJOeTQySURZd01DNHpJRFU1Tnk0MUlEVXpNeUExTVRJZ05UTXplbTB4TWpndE1URXlZVFE0SURRNElEQWdNU0F3SURrMklEQWdORGdnTkRnZ01DQXhJREF0T1RZZ01Ib2lJQzgrQ2p3dmMzWm5QZz09In0=";

    address USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewTokenURIIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER);
        moodNft.flipMood(0);
        console.log(moodNft.tokenURI(0));

        assertEq(
            keccak256(abi.encodePacked(moodNft.tokenURI(0))),
            keccak256(abi.encodePacked(SAD_MOOD_URI))
        );
    }
}
