From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3] mm: Make memory.emin the baseline for utilisation
 determination
Date: Wed, 30 Jan 2019 21:12:35 +0000
Message-ID: <20190130211226.GA6216@castle.DHCP.thefacebook.com>
References: <20190129182516.GA1834@chrisdown.name>
 <20190129190253.GA10430@chrisdown.name>
 <20190129191525.GB10430@chrisdown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tH/IbfNKhRC6ZrYi91YP5b3b99YaZHESbAqbffdYLP0=;
 b=j7RFVe1YRRvGgsrFau+tskht5dMEWRpu6r0fQ/lfty+436yrVlEsJlxpoBGqbO+vi3LH
 27BqNo+Iv9ZazaJN510Dp3AIg84uh7ioerCpFeCPsM7OU7kkqHSptP/teY6aP6/sveeX
 w6nT3neR2tJGSoNnPAjkD4EJsMWPlErZG+U= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tH/IbfNKhRC6ZrYi91YP5b3b99YaZHESbAqbffdYLP0=;
 b=KaopT+1McO7R//b2r5nPkrPXflGDzGDJtucXHNqWXU1IR4uwzohxZBYYWet5fqTKBhKuSt11NpeuoSdBjPaLsd91l1OD7+4HaiTWbges8c2c7iBijAVkxh1CtLj8zlFIjGeREdnjUp3xQAcLSxxJddhh5cP8+43GECV6zAd5AQE=
In-Reply-To: <20190129191525.GB10430@chrisdown.name>
Content-Language: en-US
Content-ID: <CC376DBE2AD86543AB31870EA097DB32@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Jan 29, 2019 at 02:15:25PM -0500, Chris Down wrote:
> Roman points out that when when we do the low reclaim pass, we scale the
> reclaim pressure relative to position between 0 and the maximum
> protection threshold.
>=20
> However, if the maximum protection is based on memory.elow, and
> memory.emin is above zero, this means we still may get binary behaviour
> on second-pass low reclaim. This is because we scale starting at 0, not
> starting at memory.emin, and since we don't scan at all below emin, we
> end up with cliff behaviour.
>=20
> This should be a fairly uncommon case since usually we don't go into the
> second pass, but it makes sense to scale our low reclaim pressure
> starting at emin.
>=20
> You can test this by catting two large sparse files, one in a cgroup
> with emin set to some moderate size compared to physical RAM, and
> another cgroup without any emin. In both cgroups, set an elow larger
> than 50% of physical RAM. The one with emin will have less page
> scanning, as reclaim pressure is lower.
>=20
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Suggested-by: Roman Gushchin <guro@fb.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: kernel-team@fb.com

Acked-by: Roman Gushchin <guro@fb.com>

Thanks!
