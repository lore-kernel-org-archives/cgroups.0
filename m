From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Mon, 25 Jul 2016 14:38:01 -0400
Message-ID: <20160725183801.GE19588@mtj.duckdns.org>
References: <20160720231949.GB19588@mtj.duckdns.org>
 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
 <20160721145242.GB22680@htj.duckdns.org>
 <1469113456.2331.16.camel@HansenPartnership.com>
 <20160721150740.GF22680@htj.duckdns.org>
 <1469114194.2331.20.camel@HansenPartnership.com>
 <20160721152648.GA23759@htj.duckdns.org>
 <1469115276.2331.23.camel@HansenPartnership.com>
 <20160721155046.GB23759@htj.duckdns.org>
 <177bbc17-5c75-1ff8-0b1f-0c5601fa7e6b@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2bexLTrGkYG30SGfJrxYT4NA+QzY6O30REcYpvu/jc8=;
        b=p9E/bH+MQDywF1YmUhiAHxJQxw5DiB1ibD5SS6vFCXZfYEcIUnlgajUJEcJfHHmyra
         t6UuXW8O0ApaWjZhrfungvmTOpLx41gt1Sa1faRkbPV1siaggcXnYwh8npzOW8hAh8DN
         APX38OgbgxEg5U6toHMojuIOd4ryKtTlvLN1rkKUA+BRIFhVN2MOYI6Q8bseuvSfnR7V
         U9sQcD7CyWPgrAQhg2T24bTRgn3p92qwAZpnx0ChO4J3inF5TP21AAjGHsSjv8Vj9ZO2
         8iC3rYxU/54d1MOUsaE2AXQl/LukyMWWYBFbQBBTZk5GBsF3nLKkHFRKIXSQNiUr7Slx
         MXXA==
Content-Disposition: inline
In-Reply-To: <177bbc17-5c75-1ff8-0b1f-0c5601fa7e6b-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

Hello, Aleksa.

On Fri, Jul 22, 2016 at 06:30:07PM +1000, Aleksa Sarai wrote:
> Just to be clear, the "ns subdir operation" is a cgroup namespaced process
> moving A -> A_subdir which is racing against some administrative process
> moving everything from A -> B (but not wanting to move A -> A_subdir)?

Yes.

> So should there be policy within the kernel to not permit a process outside
> a cgroup namespace to move processes inside the namespace? Or would you be
> concerned about people escaping the administrator's attempts to reorganise
> the hierarchy?

Pushed that far, I frankly can't assess what the implications and
side-effects would be.

> What if we extended rename(2) so that it /does/ allow for reorganisation of
> the hierarchy? So an administrator could use rename to change the point at
> which a cgroupns root is rooted at, but not be able to move the actual
> processes within the cgroup namespace around? The administrator could also
> join the cgroupns (without needing to join the userns) and then just move
> things around that way?
> 
> Do any of those suggestions seem reasonable?

Unfortunately not.  I get what you're trying to do and am sure we can
make some specific scenarios work with the right set of hacks and
holes, but this type of approach is very dangerous in the long term.

The downside we have now is that we need an explicit delegation from
userland and that stems from the architectural constraints of
cgroupfs.  It's not ideal but an acceptable situation.  Let's please
not riddle the whole thing with holes that we don't understand for an
inconvenience which can be worked around otherwise.

Thanks.

-- 
tejun
