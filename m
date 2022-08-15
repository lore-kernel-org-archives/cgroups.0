From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 cgroup/for-5.20] cgroup: Replace
 cgroup->ancestor_ids[] with ->ancestors[]
Date: Mon, 15 Aug 2022 11:17:16 -1000
Message-ID: <Yvq33G14AU0cuswB@slm.duckdns.org>
References: <YuQvcCrcgNWbtndU@slm.duckdns.org>
 <YuRJ7uzKY5/fokH5@slm.duckdns.org>
 <YuRo2PLFH6wLgEkm@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=gWg73cYfI3vn4ljKPn4NYzrF9DqHWCnArM+29mdyT+I=;
        b=JdnWdzKSg3O1vPGcLmn7GlIHnJU/Z/J6io8Fo9ke8TmxNBQVwOYCBoi66M69jVhNAb
         +9wgMaaslDSuSEQUV5pfj52eY1qRUbZ/LS4Z9UwUHPjivwimi+teLl0IixZ77o7nKeaO
         dUnInH76iDFaiADer3fl19//dgpQ7cSvpFJAb2rPPVX7xS1S87WXZay9b3LRUOHqOar+
         xRF7l3DTI4EgW15ppokevTzJQTlke5q3Zm35MpdrMsOJq45vXPM3U8eswj6d7vgLeMhu
         uRJ5C4SKERyaTiDg7tN3KphglynvwlIZSAlXnAkUo/K1Zk5SR8+9WqhJVymF9vEN/TCN
         hAXA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YuRo2PLFH6wLgEkm@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Christian Brauner <brauner@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-team@fb.com, Namhyung Kim <namhyung@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>

On Fri, Jul 29, 2022 at 01:10:16PM -1000, Tejun Heo wrote:
> Every cgroup knows all its ancestors through its ->ancestor_ids[]. There's
> no advantage to remembering the IDs instead of the pointers directly and
> this makes the array useless for finding an actual ancestor cgroup forcing
> cgroup_ancestor() to iteratively walk up the hierarchy instead. Let's
> replace cgroup->ancestor_ids[] with ->ancestors[] and remove the walking-up
> from cgroup_ancestor().
> 
> While at it, improve comments around cgroup_root->cgrp_ancestor_storage.
> 
> This patch shouldn't cause user-visible behavior differences.
> 
> v2: Update cgroup_ancestor() to use ->ancestors[].
> 
> v3: cgroup_root->cgrp_ancestor_storage's type is updated to match
>     cgroup->ancestors[]. Better comments.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Namhyung Kim <namhyung@kernel.org>

Applied to cgroup/for-6.1.

-- 
tejun
