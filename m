From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: memcontrol: fix percpu vmstats and vmevents flush
Date: Thu, 29 Aug 2019 20:40:14 +0000
Message-ID: <20190829204010.GA10855@tower.DHCP.thefacebook.com>
References: <20190829203110.129263-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=iGlhdaTjijsupVmGteNCVb/55SBkNSWK5mVb0IHyFTk=;
 b=AoyNTY731t5ybXRlKjApNrlN/VatykA9HT3d5oRsCJ4VJicvhpVM4gHBpCDTumd6rgTb
 SAiqDnJ29BAa/HdDn6NHrAAL4QCUGs2VPCIuFzFlRTbsiR+Bg9KRuhgYNeOVB9OkATZA
 dr8x5Ifpt90SL+cRRQZU0Wc3owuMtWvjg0o= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGlhdaTjijsupVmGteNCVb/55SBkNSWK5mVb0IHyFTk=;
 b=dLq3Xdjv8vxA4/zzGOM1XyXsTKnMUwC9RR4mGvlxwE5E6AwZcFOhJlkcEIW8Tg5n7fI39x+3CXzWllqE4ABJJOzl/nCBD9Wzar8QQfBvWiyYt1LOnn3DYc2NOXdTIV3NzAd1ci3MfqzWmFMRV3HxXHWjeR/2w3mxNFWRPvfDlIU=
In-Reply-To: <20190829203110.129263-1-shakeelb@google.com>
Content-Language: en-US
Content-ID: <F7A785C160390043BDF996A2B0401765@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>

On Thu, Aug 29, 2019 at 01:31:10PM -0700, Shakeel Butt wrote:
> Instead of using raw_cpu_read() use per_cpu() to read the actual data of
> the corresponding cpu otherwise we will be reading the data of the
> current cpu for the number of online CPUs.
>=20
> Fixes: bb65f89b7d3d ("mm: memcontrol: flush percpu vmevents before releas=
ing memcg")
> Fixes: c350a99ea2b1 ("mm: memcontrol: flush percpu vmstats before releasi=
ng memcg")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: <stable@vger.kernel.org>

Ouch, thanks Shakeel!

Acked-by: Roman Gushchin <guro@fb.com>
