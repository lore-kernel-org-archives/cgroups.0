From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v17 00/21] per memcg lru lock
Date: Mon, 3 Aug 2020 17:07:04 +0200
Message-ID: <20200803150704.GV5174@dhcp22.suse.cz>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <49d4f3bf-ccce-3c97-3a4c-f5cefe2d623a@linux.alibaba.com>
 <c00ac587-7f69-768a-84ea-53cbf7469ae9@linux.alibaba.com>
 <alpine.LSU.2.11.2007291105570.4649@eggly.anvils>
 <08c8797d-1935-7b41-b8db-d22f054912ac@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <08c8797d-1935-7b41-b8db-d22f054912ac-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Thu 30-07-20 10:16:13, Alex Shi wrote:
> 
> 
> 在 2020/7/30 上午2:06, Hugh Dickins 写道:
> > On Wed, 29 Jul 2020, Alex Shi wrote:
> >>
> >> Is there any comments or suggestion for this patchset?
> >> Any hints will be very appreciated.
> > 
> > Alex: it is now v5.8-rc7, obviously too late for this patchset to make
> > v5.9, so I'm currently concentrated on checking some patches headed for
> > v5.9 (and some bugfix patches of my own that I don't get time to send):
> > I'll get back to responding on lru_lock in a week or two's time.
> 
> Hi Hugh,
> 
> Thanks a lot for response! It's fine to wait longer.
> But thing would be more efficient if review get concentrated...
> I am still too new in mm area.

I am sorry and owe you a review but it is hard to find time for that.
This is a large change and the review will be really far from trivial.
If this version is mostly stable then I would recommend not posting new
versions and simply remind people you expect the review from by a
targeted ping.
-- 
Michal Hocko
SUSE Labs
