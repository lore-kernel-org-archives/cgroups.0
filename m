From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix handling of swapaccount parameter
Date: Wed, 14 Aug 2013 20:49:56 +0200
Message-ID: <20130814184956.GF24033@dhcp22.suse.cz>
References: <1376486495-21457-1-git-send-email-gergely@risko.hu>
 <20130814183604.GE24033@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130814183604.GE24033-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gergely Risko <gergely-keabAoRSNPo@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Wed 14-08-13 20:36:04, Michal Hocko wrote:
> On Wed 14-08-13 15:21:35, Gergely Risko wrote:
> > Fixed swap accounting option parsing to enable if called without argument.
> 
> We used to have [no]swapaccount but that one has been removed by a2c8990a
> (memsw: remove noswapaccount kernel parameter) so I do not think that
> swapaccount without any given value makes much sense these days.

Now that I am reading your changelog again it says this is a fix. Have
you experienced any troubles because of the parameter semantic change?

> > Signed-off-by: Gergely Risko <gergely-keabAoRSNPo@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index c290a1c..8ec2507 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6970,13 +6970,13 @@ struct cgroup_subsys mem_cgroup_subsys = {
> >  static int __init enable_swap_account(char *s)
> >  {
> >  	/* consider enabled if no parameter or 1 is given */
> > -	if (!strcmp(s, "1"))
> > +	if (*s++ != '=' || !*s || !strcmp(s, "1"))
> >  		really_do_swap_account = 1;
> >  	else if (!strcmp(s, "0"))
> >  		really_do_swap_account = 0;
> >  	return 1;
> >  }
> > -__setup("swapaccount=", enable_swap_account);
> > +__setup("swapaccount", enable_swap_account);
> >  
> >  static void __init memsw_file_init(void)
> >  {
> > -- 
> > 1.8.3.2
> > 
> > --
> > To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> > see: http://www.linux-mm.org/ .
> > Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
> 
> -- 
> Michal Hocko
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
