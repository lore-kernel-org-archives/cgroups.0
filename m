From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: Proportional memory.{low,min} reclaim
Date: Mon, 28 Jan 2019 21:52:40 +0000
Message-ID: <20190128215230.GA32069@castle.DHCP.thefacebook.com>
References: <20190124014455.GA6396@chrisdown.name>
 <20190128210031.GA31446@castle.DHCP.thefacebook.com>
 <20190128214213.GB15349@chrisdown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=LfhIbcF3M8aVM48F9+/YcRQvZsDVHnk6M8q59YUonQw=;
 b=JsV9D11IV2vMLN9eMA5RW4i5XBGbxXM2QJmvzXQZ0djf9wD+glfmcQI1zeOa4PHh/LON
 sbun26Dp8vDVdx727ngAjV4CAqjWMQqQbzWO2oxT7fR8T6raQ7yKspmrOD+PJlB209o7
 OAKio4KU00g+zxPa7QsdN2BKNDMjWVFgR0Y= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfhIbcF3M8aVM48F9+/YcRQvZsDVHnk6M8q59YUonQw=;
 b=K9ps7GQKknaMfI4k9y3HvYVKGsO2j2vURVfdPcTruD7DuAOOnPMkdPbiGSg0Ie1EWYtj3NPsTDSjI1fCFoC0J+fKiuFjDoeHoZGrm58E6Or0ibOefYQQykmh3gE7pXo7wM1sMc23lsQwPpKZXSBwYLYDxLAwRZo3B1IU9RtWb/k=
In-Reply-To: <20190128214213.GB15349@chrisdown.name>
Content-Language: en-US
Content-ID: <6FEBCAB4621E644BA86E11E1DCC17B38@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Kernel Team <Kernel-team@fb.com>

On Mon, Jan 28, 2019 at 04:42:13PM -0500, Chris Down wrote:
> Roman Gushchin writes:
> > Hm, it looks a bit suspicious to me.
> >=20
> > Let's say memory.low =3D 3G, memory.min =3D 1G and memory.current =3D 2=
G.
> > cgroup_size / protection =3D=3D 1, so scan doesn't depend on memory.min=
 at all.
> >=20
> > So, we need to look directly at memory.emin in memcg_low_reclaim case, =
and
> > ignore memory.(e)low.
>=20
> Hmm, this isn't really a common situation that I'd thought about, but it
> seems reasonable to make the boundaries when in low reclaim to be between
> min and low, rather than 0 and low. I'll add another patch with that. Tha=
nks

It's not a stopper, so I'm perfectly fine with a follow-up patch.

>=20
> > > +			scan =3D clamp(scan, SWAP_CLUSTER_MAX, lruvec_size);
> >=20
> > Idk, how much sense does it have to make it larger than SWAP_CLUSTER_MA=
X,
> > given that it will become 0 on default (and almost any other) priority.
>=20
> In my testing, setting the scan target to 0 and thus reducing scope for
> reclaim can result in increasing the scan priority more than is desirable=
,
> and since we base some vm heuristics based on that, that seemed concernin=
g.
>=20
> I'd rather start being a bit more cautious, erring on the side of scannin=
g
> at least some pages from this memcg when priority gets elevated.
>=20
> Thanks for the review!

For the rest of the patch:
Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!
