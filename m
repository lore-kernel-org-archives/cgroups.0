From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Thu, 21 Jul 2016 11:01:35 -0400
Message-ID: <20160721150135.GD22680@htj.duckdns.org>
References: <20160718161816.13040-1-asarai@suse.de>
 <20160718161816.13040-4-asarai@suse.de>
 <20160720155147.GG4574@htj.duckdns.org>
 <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
 <20160720230228.GA19588@mtj.duckdns.org>
 <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
 <20160720231949.GB19588@mtj.duckdns.org>
 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
 <20160721143330.GA5751@mail.hallyn.com>
 <2dc90947-cee7-90a9-3e60-4ca7c0de29d3@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QkKe5ISKIsN1a1HH9pBSCt71thZZJQvm681LZhat2k8=;
        b=nSKRVTO7rw12HIfqXR3J4rDZhzj0VUe7jXI35HxL1Qjs4uhUkvGp7NPhfyHXccZA8A
         +5aePjfYFfRCcB1bPse/eb3C6QJ+Qx5sKsZTJO2+WXIro3xv8StgnntmgwkfE+smfUIV
         j61Y40w/9EImo5VPV4cP/g7uC/pLI4b+b1kRYKzHY3tLgI4D/Igr/BmIHbS47tOBl2IP
         330OtUIt6VXnrYnOrdOcSh0rtbq7TDf8mKP1mbdm7FHVJpjq//I/Vk104YQaWKQR85JY
         62+DHdJPZRWizw9tQFeIugdiL6D0kYgcGdESY6k2XYqYhLwceF7lzbmZwQFKJor6JmnV
         Uq+g==
Content-Disposition: inline
In-Reply-To: <2dc90947-cee7-90a9-3e60-4ca7c0de29d3-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

Hello, Aleksa.

On Fri, Jul 22, 2016 at 12:37:42AM +1000, Aleksa Sarai wrote:
> > Ths is of course solvable using something like libpam-cgfs or
> > libpam-cgm (and others).  Since this sounds like a question of
> > policy, not mechanism, userspace seems like the right place.  Is
> > there a downside to that (or, as Tejun put it, "delegating explicitly")?
> 
> Having a PAM module requires getting an administrator to install the PAM
> module (and also presumably audit it, not to mention convincing them that
> your requirement to use containers are significant enough for them to do any
> work). It's the same problem IMO. I understand that LXC allows you to do
> this, but it requires that you get an administrator to *install* and support
> LXC (as well as the shadow-utils setuid binaries too). There are cases where
> you don't have the freedom to do that, and also "just get someone to give
> you privileges temporarily" is again punting on the problem.

The administrator has to install a new kernel to get this feature from
kernel side too.  I don't think "to bypass admin" is a strong argument
for a new kernel feature especially when it's likely to cause subtle
issues as in this case.

Thanks.

-- 
tejun
