From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Wed, 27 Nov 2013 01:53:24 +0000
Message-ID: <20131127015324.GB31364@mail.hallyn.com>
References: <20131125224335.GA15481@mail.hallyn.com>
	<CAO_RewZGWARUafKzDc_t3G5OedGtEPTZgB2VYeHHiKSSrja8fA@mail.gmail.com>
	<20131126054718.GA19134@mail.hallyn.com>
	<CAO_RewZ8cUn-PdXfQF0yH=V=9UqE7Yo1JX2pt2c71WYDrpYE0Q@mail.gmail.com>
	<20131126205819.GA27266@mail.hallyn.com>
	<CAO_RewZh+dNkUdZdu-R3CKTvYzbPL50v-BsBHvek75ti3V6kZQ@mail.gmail.com>
	<20131126212814.GA27602@mail.hallyn.com>
	<CAD=mX8uuAeN7s8ZA6Gc-wsBd6-PHevBRyBL6hMAS9VW15T5eYA@mail.gmail.com>
	<CAO_RewY0eFTgkVqbRJwdW9bgR3nz9h5t6c823wFH5cg1CD0sEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lxc-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAO_RewY0eFTgkVqbRJwdW9bgR3nz9h5t6c823wFH5cg1CD0sEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/lxc-devel>,
	<mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=lxc-devel>
List-Post: <mailto:lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/lxc-devel>,
	<mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: lxc-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

I was planning on doing #3, but since you guys need to access .., my
plan is to have 'a/b' refer to $cwd/a/b while /a/b is the absolute
path, and allow read and eventfd but no write to any parent dirs.

Quoting Tim Hockin (thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> I see three models:
> 
> 1) Don't "virtualize" the cgroup path.  This is what lmctfy does,
> though we have discussed changing to:
> 
> 2) Virtualize to an "administrative root" - I get to tell you where
> your root is, and you can't see anythign higher than that.
> 
> 3) Virtualize to CWD root - you can never go up, just down.
> 
> 
> #1 seems easy, but exposes a lot.  #3 is restrictive and fairly easy -
> could we live with that?  #2 seems ideal, but it's not clear to me how
> to actually implement it.
> 
> On Tue, Nov 26, 2013 at 1:31 PM, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > I think most of our usecases have only wanted to know about the parent, but
> > I can see people wanting to go further. Would it be much different to
> > support both? I feel like it'll be simpler to support all if we go that
> > route.
> >
> >
> > On Tue, Nov 26, 2013 at 1:28 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> >>
> >> Quoting Tim Hockin (thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> >> > lmctfy literally supports ".." as a container name :)
> >>
> >> So is ../.. ever used, or does noone every do anything beyond ..?
> >
> >

------------------------------------------------------------------------------
Rapidly troubleshoot problems before they affect your business. Most IT 
organizations don't have a clear picture of how application performance 
affects their revenue. With AppDynamics, you get 100% visibility into your 
Java,.NET, & PHP application. Start your 15-day FREE TRIAL of AppDynamics Pro!
http://pubads.g.doubleclick.net/gampad/clk?id=84349351&iu=/4140/ostg.clktrk
