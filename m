From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [lxc-devel] cgroup management daemon
Date: Wed, 4 Dec 2013 09:54:37 -0600
Message-ID: <20131204155437.GA29008@sergelap>
References: <20131125224335.GA15481@mail.hallyn.com>
 <20131203134506.GG8277@htj.dyndns.org>
 <20131204000344.GB24968@sergelap>
 <20131204012416.GY8277@htj.dyndns.org>
 <20131204023151.GA12376@sergelap>
 <CAO_RewbZiLCJcO9G7pgxN8ZxkkVdEW1B84nkQ5wX3a9DPq4zfg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAO_RewbZiLCJcO9G7pgxN8ZxkkVdEW1B84nkQ5wX3a9DPq4zfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Quoting Tim Hockin (thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> If this daemon works as advertised, we will explore moving all write
> traffic to use it.  I still have concerns that this can't handle read
> traffic at the scale we need.
> 
> Tejun,  I am not sure why chown came back into the conversation.  This
> is a replacement for that.

Because the daemon is chowning directories and files.  That's how
the daemon decides whether clients have access.

-serge
