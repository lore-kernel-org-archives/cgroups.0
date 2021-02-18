From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 4/8] cgroup: rstat: support cgroup1
Date: Thu, 18 Feb 2021 12:06:42 -0500
Message-ID: <YC6eojaku6oaOqA2@cmpxchg.org>
References: <20210209163304.77088-1-hannes@cmpxchg.org>
 <20210209163304.77088-5-hannes@cmpxchg.org>
 <20210217174232.GA19239@blackbody.suse.cz>
 <YC2CKyaeF2bqvpMk@cmpxchg.org>
 <YC6Lh8BRfMA2Ppdk@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zVENMey1EdFzZhk4Yon7dEXfrybku0MTAsUKJNMONig=;
        b=Y1SWeFTKNyObDh6T0tVdAgoEZMOAylAVj0RaiIh4kAxsIwLKcsBRG7tkJfxs3cHEKu
         NOWc39l8M1vBqjKsIMnc+AtNj0YWSFBUUDAUFpgpXHuzPzLnk3MRbun/IK0sJH9iZqCi
         RdKo6WX4ySkyoeKwlC94IFZsf1Ggdowq/47IJqc+GCWUnkGbAfJudf0kZ1qCFSoUNHHv
         dY/nu1cl5r8HS/JXRG7goGXAtXL1RrdpPQrPCdy4hfiG1WW/Jl8mkMBXUYgonM//jEni
         tEXmFMLO5cKxRzFHrI9OfkDp/+N6LspjAeUDpjjPIkd3xT5lsvZV4/93GtGUolxXXHfH
         c9TQ==
Content-Disposition: inline
In-Reply-To: <YC6Lh8BRfMA2Ppdk@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Feb 18, 2021 at 04:45:11PM +0100, Michal Koutn=FD wrote:
> On Wed, Feb 17, 2021 at 03:52:59PM -0500, Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> > In this case, we're talking about a relatively small data structure
> > and the overhead is per mountpoint.
> IIUC, it is per each mountpoint's number of cgroups. But I still accept
> the argument above. Furthermore, this can be changed later.

Oops, you're right of course.

> > The default root group has statically preallocated percpu data before
> > and after this patch. See cgroup.c:
> I stand corrected, the comment is still valid.
>=20
> Therefore,
> Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

Thanks for your reviews, Michal!
