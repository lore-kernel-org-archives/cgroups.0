From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-5.19-fixes] cgroup: Use separate src/dst nodes
 when preloading css_sets for migration
Date: Thu, 16 Jun 2022 09:38:44 -1000
Message-ID: <YquGxN1IWLegNyh6@slm.duckdns.org>
References: <549de740-1356-7ad2-3ee5-c52bc355fd99@quicinc.com>
 <Yh+RGIJ0f3nrqIiN@slm.duckdns.org>
 <8d21e655-4ce9-c7b3-2010-e484161bdbe9@quicinc.com>
 <20220516203417.GY1790663@paulmck-ThinkPad-P17-Gen-1>
 <9a93cf2d-0efe-5a46-dcd5-7dcd8f173188@quicinc.com>
 <Yqe4BjMZRohur3UM@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3mANjjY0moGxiXZnHLX+UHOhvERe+q5moP+dgBuCZ9M=;
        b=F9CvRl3u0bPQkegn8gRDzTFpWVRsfPRpQInrBIe0BVAlITR/VWYRRA4RaFrE1lJ1BN
         QxOPr5FPEK7ztGZKRsasgt/szMabvzttgNQVb6YRE/J+GWn8Stg4Vse23xGOe+nL0Vi+
         oiTdkNApvaHhAmQdM+bRBQxjIvFtyNw8XoGkJ3auyWS3Je5pWqzGomJkA9LODLwhvxtC
         lgo3KyUHcvXBM8/Ac5BQIq8v9JKGO45rDaVaEWSRRimbJP0SbQaCElw22ENg/zyshET3
         +xY//2BI38BXicqIzmJGJGA2wyWUMOYoi858u/xLbGZkFFq3N1UYF+2HDkHv+i3CUNjp
         AFUQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Yqe4BjMZRohur3UM-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Cc: paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shisiyuan <shisiyuan19870131-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Mon, Jun 13, 2022 at 12:19:50PM -1000, Tejun Heo wrote:
> Each cset (css_set) is pinned by its tasks. When we're moving tasks around
> across csets for a migration, we need to hold the source and destination
> csets to ensure that they don't go away while we're moving tasks about. This
> is done by linking cset->mg_preload_node on either the
> mgctx->preloaded_dst_csets or mgctx->preloaded_dst_csets list. Using the
> same cset->mg_preload_node for both the src and dst lists was deemed okay as
> a cset can't be both the source and destination at the same time.

Applied to cgroup/for-5.19-fixes w/ patch description fixed.

Thanks.

-- 
tejun
