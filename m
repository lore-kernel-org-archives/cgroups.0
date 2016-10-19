From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IPC: account for kmem usage on mqueue and msg
Date: Wed, 19 Oct 2016 09:55:05 +0200
Message-ID: <20161019075505.GA7517@dhcp22.suse.cz>
References: <1476806075-1210-1-git-send-email-arozansk@redhat.com>
 <20161018182619.GB27792@dhcp22.suse.cz>
 <20161018193021.GA2953@p183.telecom.by>
 <CAFtQ=dr2zGqeHtw84UGP8615TaWg92_n7nZPfn2qZkxDA1zN5Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFtQ=dr2zGqeHtw84UGP8615TaWg92_n7nZPfn2qZkxDA1zN5Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stefan Schimanski <sttts-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed 19-10-16 09:46:58, Stefan Schimanski wrote:
> The production use case at hand is that mqueues should be customizable via
> sysctls in Docker containers in a Kubernetes cluster. This can only be
> safely allowed to the users of the cluster (without the risk that they can
> cause resource shortage on a node, influencing other users' containers) if
> all resources they control are bounded, i.e. accounted for.

THis is a valuable information and should be a part of the changelog
IMHO. 

> On Tue, Oct 18, 2016 at 9:30 PM, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> wrote:
> 
> > On Tue, Oct 18, 2016 at 08:26:19PM +0200, Michal Hocko wrote:
> > > On Tue 18-10-16 11:54:35, Aristeu Rozanski wrote:
> > > > When kmem accounting switched from account by default to only account
> > if
> > > > flagged by __GFP_ACCOUNT, IPC mqueue and messages was left out.
> > >
> > > I guess this was because ipv msgqueue shouldn't allow for memory
> > > consumption runaways. The number of message queues and messages pending
> > > in them is bounded and not a large amount of memory AFAIR. Anyway I do
> > > not see anything unreasonable about accounting the memory to the caller.
> >
> > It should be accounted because receiver may not intentionally or
> > unintentionally
> > consume messages.
> >

-- 
Michal Hocko
SUSE Labs
