From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V7 10/14] hugetlbfs: Add new HugeTLB cgroup
Date: Thu, 31 May 2012 11:43:56 +0200
Message-ID: <20120531094355.GB12809@tiehlicka.suse.cz>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1338388739-22919-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120531011953.GE401@localhost.localdomain>
 <20120531054316.GD24855@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120531054316.GD24855-6yE53ggjAfyuJw1Jpgb2kA4V1jybR7bhVpNB7YpNyf8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Konrad Rzeszutek Wilk <konrad-Gq0aWv8utHQdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 31-05-12 11:13:16, Aneesh Kumar K.V wrote:
> On Wed, May 30, 2012 at 09:19:54PM -0400, Konrad Rzeszutek Wilk wrote:
[...]
> > > +static struct cgroup_subsys_state *hugetlb_cgroup_create(struct cgroup *cgroup)
> > > +{
> > > +	int idx;
> > > +	struct cgroup *parent_cgroup;
> > > +	struct hugetlb_cgroup *h_cgroup, *parent_h_cgroup;
> > > +
> > > +	h_cgroup = kzalloc(sizeof(*h_cgroup), GFP_KERNEL);
> > > +	if (!h_cgroup)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > 
> > No need to check cgroup for NULL?
> 
> Other cgroups (memcg) doesn't do that. Can we really get NULL cgroup tere ?

No we cannot. See cfa449461e67b60df986170eecb089831fa9e49a

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
