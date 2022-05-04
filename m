From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v6 1/6] gpu: rfc: Proposal for a GPU cgroup controller
Date: Wed, 4 May 2022 14:10:52 +0200
Message-ID: <20220504121052.GA24172@blackbody.suse.cz>
References: <20220502231944.3891435-1-tjmercier@google.com>
 <20220502231944.3891435-2-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651666254; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GbtrdowooXgC4Dq4I7PP0O0e6k1pK88440d13xBhK68=;
        b=gvyorl1e9bnZvu9SbWDa+u1KYleZB6uYGpnI0dQX9V+DB6u4vxbQu5qltnYvmQiei1rLaI
        TqiXg4X62CL/MZ4++gP+Oz/1JpJPP9PTjUOlGcSOfSxUrVHSQIqjBIGQ3yGsIhE2RWpvOv
        bVYG1gSmsZ0Q0ATa/1Ic7LH6FnCUC5M=
Content-Disposition: inline
In-Reply-To: <20220502231944.3891435-2-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, daniel-/w4YWyX8dFk@public.gmane.org, hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org, jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello.

On Mon, May 02, 2022 at 11:19:35PM +0000, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> [...]
> +	The device name string is set by a device driver when it registers with the
> +	GPU cgroup controller to participate in resource accounting. 

Are these names available anywhere else for the user? (I.e. would
drivers add respective sysfs attributes or similar?)


> +     Non-unique names will be rejected at the point of registration.

This doesn't seem relevant to the cgroupfs user, does it?
I think it should be mentioned at the respective API.

HTH,
Michal

