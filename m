From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [lxc-devel] cgroup management daemon
Date: Wed, 4 Dec 2013 09:56:57 -0600
Message-ID: <20131204155657.GB29008@sergelap>
References: <20131125224335.GA15481@mail.hallyn.com>
 <20131203134506.GG8277@htj.dyndns.org>
 <20131204000344.GB24968@sergelap>
 <20131204012416.GY8277@htj.dyndns.org>
 <20131204023151.GA12376@sergelap>
 <CAO_RewbZiLCJcO9G7pgxN8ZxkkVdEW1B84nkQ5wX3a9DPq4zfg@mail.gmail.com>
 <CAD=mX8seoMfM63hOwbmJ_0GdS-fa8H6fB40k8uyqBNbSVqfXrA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAD=mX8seoMfM63hOwbmJ_0GdS-fa8H6fB40k8uyqBNbSVqfXrA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Quoting Victor Marmol (vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> I thought we were going to use chown in the initial version to enforce the
> ownership/permissions on the hierarchy. Only the cgroup manager has access
> to the hierarchy, but it tries to access the hierarchy as the user that
> sent the request. It was only meant to be a "for now" solution while the
> real one rolls out. It may also have gotten thrown out since last I heard :)

Actually that part wasn't meant as a "for now" solution.  It can of
course be thrown away in favor of having the daemon store all this
information, but I'm seeing no advantages to that right now.

There are other things which the daemon can eventually try to keep
track of, if we don't decide they belong in a higher layer.

-serge
