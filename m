From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: Add memory.transparent_hugepage_disabled
Date: Tue, 24 Mar 2020 14:17:36 +0100
Message-ID: <20200324131736.GN19542@dhcp22.suse.cz>
References: <1585045916-27339-1-git-send-email-teawater@gmail.com>
 <20200324110034.GH19542@dhcp22.suse.cz>
 <816B70EC-20AD-4BB8-AD13-4F5640EBAB35@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <816B70EC-20AD-4BB8-AD13-4F5640EBAB35-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: teawater <teawaterz-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Hui Zhu <teawater-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, thellstrom-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue 24-03-20 20:30:32, teawater wrote:
> 
> 
> > 2020年3月24日 19:00，Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> 写道：
> > 
> > On Tue 24-03-20 18:31:56, Hui Zhu wrote:
> >> /sys/kernel/mm/transparent_hugepage/enabled is the only interface to
> >> control if the application can use THP in system level.
> >> Sometime, we would not want an application use THP even if
> >> transparent_hugepage/enabled is set to "always" or "madvise" because
> >> thp may need more cpu and memory resources in some cases.
> > 
> > Could you specify that sometime by a real usecase in the memcg context
> > please?
> 
> 
> Thanks for your review.
> 
> We use thp+balloon to supply more memory flexibility for vm.
> https://lore.kernel.org/linux-mm/1584893097-12317-1-git-send-email-teawater-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/
> This is another thread that I am working around thp+balloon.
> 
> Other applications are already deployed on these machines.  The
> transparent_hugepage/enabled is set to never because they used to have
> a lot of THP related performance issues.  And some of them may call
> madvise thp with itself.

If they call madvise then they clearly indicate they prefer THP
regardless the cost. So I really fail to see what memcg specific tuning
brings in.

Could you be more specific about the usecase that cannot work with the
existing THP tuning?
-- 
Michal Hocko
SUSE Labs
