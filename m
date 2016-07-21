From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Thu, 21 Jul 2016 17:06:20 -0400
Message-ID: <20160721210620.GD23759@htj.duckdns.org>
References: <20160720231949.GB19588@mtj.duckdns.org>
 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
 <20160721145242.GB22680@htj.duckdns.org>
 <1469113456.2331.16.camel@HansenPartnership.com>
 <20160721150740.GF22680@htj.duckdns.org>
 <1469114194.2331.20.camel@HansenPartnership.com>
 <20160721152648.GA23759@htj.duckdns.org>
 <1469115276.2331.23.camel@HansenPartnership.com>
 <20160721155046.GB23759@htj.duckdns.org>
 <1469125002.2331.54.camel@HansenPartnership.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BvDG8aWw+NhEHeEuMI48TF9p0W0fjn99BN0uTsH9Lx8=;
        b=PoHMtlqS0kfk81H8mtC3xudu0XKsZkBhpc17HKgwARLZH3YLZWDXfP6pK4e+8dfiHD
         +3E0lNwqMxNgiLHXJQmSoNsEUfacbFR6aPjwblBxjrUx+TJ/tmMUlJuikSfxyUOw+RG5
         bNTZBL7Cjbjzr3GYmA6NkpgzRSmh9qbqqlQSf6J2FTCjH5S1iSey6HIHxTmOcBuri330
         KHhuyBF2aM6mrUd1LrV5uNydrI8ofU7QTiiyJdUXeCnhEqyDVLNSRosIGtmgFrvZWfRr
         aNqVnrIKImNOpjHoNV/OHz4SIs6sIh+qK/RbBaMKrDD5402SBwre8vEMUv+EnhUtNkyW
         kBRA==
Content-Disposition: inline
In-Reply-To: <1469125002.2331.54.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

Hello,

On Thu, Jul 21, 2016 at 11:16:42AM -0700, James Bottomley wrote:
> OK so a theoretical (not saying it's implementable, we'll have to
> explore that) way of fixing all of this is to have separate views of
> the tree.  If the admin always saw everything in A, even if the
> cgroupns had created subdirectories in its own namespace.  That way
> there'd be no race ever in the admin's view (because it's the view they
> created and would expect to see).  All sub cgroup activity would only
> be visible to tasks in the new cgroupns (we'd probably have to have
> them make this visible by mounting a new cgroup tree).

Yeah, something like that.  The two domains of operation need to be
transparent to each other so that things taking place at system level
doesn't interfere with user level operations and vice-versa.  It's
likely that implementing something like that within filesystem based
interface won't work out too well.  There are too many expected
behaviors from being a filesystem which don't quite agree with such
abstraction.

Thanks.

-- 
tejun
