From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Wed, 20 Jul 2016 19:19:49 -0400
Message-ID: <20160720231949.GB19588@mtj.duckdns.org>
References: <20160718161816.13040-1-asarai@suse.de>
 <20160718161816.13040-4-asarai@suse.de>
 <20160720155147.GG4574@htj.duckdns.org>
 <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
 <20160720230228.GA19588@mtj.duckdns.org>
 <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=U1PySDEZI8Zstj3YiEi7iCeZVNg/l9dzWuUJU4JyohA=;
        b=WBJ2aYSjxvQ2wFtx6ga3ZzPmaDwnRuXLty7nmEcPjzWP1NOVsg6wpQ/Ufr5I9r6qLH
         FTfuNABK+IDySo8UjPVVoUbGKZgiIRDFbThrBUnvZ32OQQzeQjE3umInLGKkU8xE3npE
         gnPEh6yVOagNOmKRJ1FHKFbEawpPWW6bgIf+mfTQTNRFEaeJY1zEQDdVC9ScGb409NbM
         CwscGEVn0QQv8lg1R5t6TS0ajixpnd6MRzY/16uvD5OrDYexCCpyWlOA29yhF5xp54as
         Yy4qLFT4TqvoFi6/9Zdn3n1x9itTOc5QQTYaTtK7fUVfndGX3vwR1Q1DBGuz1U8JNC8o
         5U4A==
Content-Disposition: inline
In-Reply-To: <982fcf3a-3685-9bd7-dd95-7bff255c9421-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

Hello, Aleksa.

On Thu, Jul 21, 2016 at 09:18:59AM +1000, Aleksa Sarai wrote:
> I feel like the permission model makes sense in certain cases (the common
> ancestor restriction, as well as the ability for a parent to apply limits to
> children by setting its own limits). Neither of those are violated (if you
> read the commit that introduced the common ancestor restriction).
>
> Maybe if you give me a usecase of when it might be important that a process
> must not be able to move to a sub-cgroup of its current one, I might be able
> to understand your concerns? From my perspective, I think that's actually
> quite useful.

cgroup is used to keep track of which processes belong where and
allowing processes to be moved out of its cgroup like this would be
surprising to say the least.

> > Maybe I'm misunderstanding but I can't see how that would change the
> > situation in a significant way.
> 
> Well, it would avoid the issue of a process being moved against *its* will.
> The process would have to be complicit in joining (or unsharing) a cgroup
> namespace. I'm not sure I really agree with the argument that a higher level
> process should be able to stop a process from imposing more *stringent*
> limits on itself if the process is complicit in setting those limits (see
> above).
> 
> The reason I'm doing this is so that we might be able to _practically_ use
> cgroups as an unprivileged user (something that will almost certainly be
> useful to not just the container crowd, but people also planning on using
> cgroups as advanced forms of rlimits).

I don't get why we need this fragile dance with permissions at all
when the same functionality can be achieved by delegating explicitly.

Thanks.

-- 
tejun
