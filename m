From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC v5 0/6] Proposal for a GPU cgroup controller
Date: Fri, 22 Apr 2022 16:53:00 +0200
Message-ID: <YmLBTBd+5RHzr9MK@kroah.com>
References: <20220420235228.2767816-1-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650639183;
        bh=T9UBwXuqufvpPkwkvMfLrSuvMpCvswDkzG2OAhXGXms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gtR6ueBjj90k6uXG+sGb62mjEPhUyWqCc4g/LYsDAGDC86QvoXlQYy95NhT2btdF8
         P0xl3sQ3qmwmyqmSN38lcytsJbQgKvLmqdrL0dhCwz49yEBz1tKjoPpydxABJtmKdz
         GxSusnTu+4goI0K1PWwTnb2+/G0VhcVxFy2lzYdc=
Content-Disposition: inline
In-Reply-To: <20220420235228.2767816-1-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: daniel-/w4YWyX8dFk@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Starkey <B>

On Wed, Apr 20, 2022 at 11:52:18PM +0000, T.J. Mercier wrote:
> This patch series revisits the proposal for a GPU cgroup controller to
> track and limit memory allocations by various device/allocator
> subsystems. The patch series also contains a simple prototype to
> illustrate how Android intends to implement DMA-BUF allocator
> attribution using the GPU cgroup controller. The prototype does not
> include resource limit enforcements.
> 
> Changelog:
> v5:
> Rebase on top of v5.18-rc3

Why is a "RFC" series on v5?  I treat "RFC" as "not ready to be merged,
if people are interested, please look at it".  But v5 seems like you
think this is real.

confused,

greg k-h
