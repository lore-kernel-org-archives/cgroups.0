From: Dima Zavin <dmitriyz@waymo.com>
Subject: Re: [RFC PATCH] mm/slub: fix a deadlock due to incomplete patching of cpusets_enabled()
Date: Wed, 26 Jul 2017 12:52:56 -0700
Message-ID: <CAPz4a6AtLNf8sJzA2Ux-ta4B+_YLdG7OWEMvJij_Zguo0Q1sjw@mail.gmail.com>
References: <20170726165022.10326-1-dmitriyz@waymo.com> <alpine.DEB.2.20.1707261158560.9311@nuc-kabylake>
Reply-To: dmitriyz@waymo.com
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="001a114b42406c89a005553dcb01"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waymo.com; s=google;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=xTnj7GHcM0fCyfaJDY86U7kf9eMxuBmc34Jq7ICbkU8=;
        b=VXzpC22uIL0TDFHnBtL1OGOOSlf2VE8vY4lnaxSFLz6W6jcpnJPLrx66PyZJ4ZHcGz
         MKZK5Y9tTxzaeUp2kzxfRkiKUaQXm/S24SzZCheqbgUwyKVCCy5gL5buMn6a1ZiZ0o5v
         tz3EmH4M3Fy6CKc19FISXQmfUm8mlSTDS8yYc=
In-Reply-To: <alpine.DEB.2.20.1707261158560.9311@nuc-kabylake>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
To: Christopher Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Cliff Spradlin <cspradlin@waymo.com>

--001a114b42406c89a005553dcb01
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 26, 2017 at 10:02 AM, Christopher Lameter <cl@linux.com> wrote:

> On Wed, 26 Jul 2017, Dima Zavin wrote:
>
> > The fix is to cache the value that's returned by cpusets_enabled() at the
> > top of the loop, and only operate on the seqlock (both begin and retry)
> if
> > it was true.
>
> I think the proper fix would be to ensure that the calls to
> read_mems_allowed_{begin,retry} cannot cause the deadlock. Otherwise you
> have to fix this in multiple places.
>
> Maybe read_mems_allowed_* can do some form of synchronization or *_retry
> can implictly rely on the results of cpusets_enabled() by *_begin?
>

Thanks for the quick reply!

I can turn the cookie into a uint64, put the sequence into the low order 32
bits and put the enabled state into bit 33 (or 63 :) ). Then retry will not
query cpusets_enabled() and will just look at the enabled bit. This means
that *_retry will always have a conditional jump (i.e. lose the whole
static_branch optimization) but maybe that's ok since that's pretty rare
and the *_begin() will still benefit from it?

--Dima

--001a114b42406c89a005553dcb01
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Wed, Jul 26, 2017 at 10:02 AM, Christopher Lameter <span dir=3D"ltr"=
>&lt;<a href=3D"mailto:cl@linux.com" target=3D"_blank">cl@linux.com</a>&gt;=
</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Wed, 2=
6 Jul 2017, Dima Zavin wrote:<br>
<br>
&gt; The fix is to cache the value that&#39;s returned by cpusets_enabled()=
 at the<br>
&gt; top of the loop, and only operate on the seqlock (both begin and retry=
) if<br>
&gt; it was true.<br>
<br>
</span>I think the proper fix would be to ensure that the calls to<br>
read_mems_allowed_{begin,<wbr>retry} cannot cause the deadlock. Otherwise y=
ou<br>
have to fix this in multiple places.<br>
<br>
Maybe read_mems_allowed_* can do some form of synchronization or *_retry<br=
>
can implictly rely on the results of cpusets_enabled() by *_begin?<br></blo=
ckquote><div><br></div><div>Thanks for the quick reply!</div><div><br></div=
><div>I can turn the cookie into a uint64, put the sequence into the low or=
der 32 bits and put the enabled state into bit 33 (or 63 :) ). Then retry w=
ill not query cpusets_enabled() and will just look at the enabled bit. This=
 means that *_retry will always have a conditional jump (i.e. lose the whol=
e static_branch optimization) but maybe that&#39;s ok since that&#39;s pret=
ty rare and the *_begin() will still benefit from it?</div><div><br></div><=
div>--Dima</div></div></div></div>

--001a114b42406c89a005553dcb01--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
