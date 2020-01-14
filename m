From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Patch v2] mm: thp: grab the lock before manipulation defer list
Date: Tue, 14 Jan 2020 10:31:22 +0100
Message-ID: <20200114093122.GH19428@dhcp22.suse.cz>
References: <20200109143054.13203-1-richardw.yang@linux.intel.com>
 <20200111000352.efy6krudecpshezh@box>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200111000352.efy6krudecpshezh@box>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Sat 11-01-20 03:03:52, Kirill A. Shutemov wrote:
> On Thu, Jan 09, 2020 at 10:30:54PM +0800, Wei Yang wrote:
> > As all the other places, we grab the lock before manipulate the defer list.
> > Current implementation may face a race condition.
> > 
> > For example, the potential race would be:
> > 
> >     CPU1                      CPU2
> >     mem_cgroup_move_account   split_huge_page_to_list
> >       !list_empty
> >                                 lock
> >                                 !list_empty
> >                                 list_del
> >                                 unlock
> >       lock
> >       # !list_empty might not hold anymore
> >       list_del_init
> >       unlock
> 
> I don't think this particular race is possible. Both parties take page
> lock before messing with deferred queue, but anytway:
> 
> Acked-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

I am confused, if the above race is not possible then what would be a
real race? We really do not want to have a patch with a misleading
changelog, do we?
-- 
Michal Hocko
SUSE Labs
