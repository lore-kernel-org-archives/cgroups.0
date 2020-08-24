From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Resend PATCH 1/6] mm/memcg: warning on !memcg after readahead
 page charged
Date: Mon, 24 Aug 2020 17:10:45 +0200
Message-ID: <20200824151045.GC3415@dhcp22.suse.cz>
References: <1597144232-11370-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200820145850.GA4622@lca.pw>
 <20200824145201.GB4337@lca.pw>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200824145201.GB4337-J5quhbR+WMc@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 24-08-20 10:52:02, Qian Cai wrote:
> On Thu, Aug 20, 2020 at 10:58:50AM -0400, Qian Cai wrote:
> > On Tue, Aug 11, 2020 at 07:10:27PM +0800, Alex Shi wrote:
> > > Since readahead page is charged on memcg too, in theory we don't have to
> > > check this exception now. Before safely remove them all, add a warning
> > > for the unexpected !memcg.
> > > 
> > > Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> > > Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > 
> > This will trigger,
> 
> Andrew, Stephen, can you drop this series for now? I did manage to trigger this
> warning on all arches, powerpc, x86 and arm64 (below).

Yes, I do agree. See http://lkml.kernel.org/r/20200824151013.GB3415-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org
-- 
Michal Hocko
SUSE Labs
