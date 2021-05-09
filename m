From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: Re: v2 cpu.max question
Date: Sun, 9 May 2021 15:32:02 +0200
Message-ID: <CAFpoUr3WX25TjT9hRtmbSaJ7ttDePGxSGuDjJcs2bhOGe3o_=A@mail.gmail.com>
References: <0102017951491312-b3c91c35-577a-466c-965b-fa004d314980-000000@eu-west-1.amazonses.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F49D02pxiMmGycYPdlDKlqkb/EJSemndZuTA7fp/VFQ=;
        b=wBcnT6KuAw/3Cv7Gc32c+74PWGVbiRTsugauRCCtiraGEbkG+/kUK+i8RiSKoUW6eU
         XYrzFUvgUv5fKUwVUzO4heOxy4K2o0TefSwgvoKeJZdogDWcp4/TFObuAk5Icn6ubhOW
         VTAHUPCRQ75E5sZlnfHAx7D8j1dUA+arUu9+UmI6Y9pCHXWVcDVJWmTsYSFi7gfnBhpt
         ckGGRhkdk2lvJz9SjQkKOxPxumTcUqPp+llCbYDaKT5R3Z1hKAGTkucsD27Wlidbn42H
         LaSgPOz2KTNAexGqxgLJSZVbKLFtnjNLi5kU4CsFxumt8vajVSAL92H2WoE2I//+io8S
         ILYA==
In-Reply-To: <0102017951491312-b3c91c35-577a-466c-965b-fa004d314980-000000-zGoQ1LgHIBOb5FkPbArKWlNw9kRHFGba@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Patrick Reader <_@pxeger.com>
Cc: "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,


s=C3=B8n. 9. mai 2021 kl. 15:20 skrev Patrick Reader <_@pxeger.com>:
> "the group may consume upto $MAX in each $PERIOD duration". But $MAX what=
? Microseconds? Clock cycles? Arbitrary CPU scheduling units with only a re=
lative meaning? Elephants? At the moment I don't know what values are sensi=
ble to set here.

Those numbers are in microseconds.

If you look at the "conventions" sections of the cgroup v2 docs [0],
it states; "The default time unit is microseconds. If a different unit
is ever used, an explicit unit suffix must be present."

[0]: https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html#conv=
entions

Thanks,
Odin
