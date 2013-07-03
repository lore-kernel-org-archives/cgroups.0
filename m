From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: cgroup: status-quo and userland efforts
Date: Wed, 3 Jul 2013 09:37:40 +0200
Message-ID: <20130703073740.GA14096@pd.tnic>
References: <20130628040930.GC2500@htj.dyndns.org>
 <1372394950.5989.128.camel@marge.simpson.net>
 <20130628050138.GD2500@htj.dyndns.org>
 <20130628150513.GD5125@dhcp22.suse.cz>
 <CAAAKZwtqYe-c0bfkgHFbzsOKVHifjTwkqcpci=uS1JwqS9TJHQ@mail.gmail.com>
 <51CE3CE0.9010506@redhat.com>
 <CAAAKZwuzhSzPj99HZW=KD4emGXZbcsjsUu=+TCpafhs9MKD2JA@mail.gmail.com>
 <51D08976.6040005@redhat.com>
 <alpine.DEB.2.02.1307030021480.4013@ionos.tec.linutronix.de>
 <CAPXgP12AyogbFX_hPPmQD5GFG0-+_crsnHF3epDZSRds3-WNtQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=alien8.de; s=alien8;
	t=1372837062; bh=UzAsjmBS+2S67wNsB0+/hm95uTWWHxMemA3v/enxcXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To; b=sqdibYcRh7JKxPIvGnlGltC04q21KnnwqXu2je
	U+ZWwRXlPlybU8F7cRfOqF8ZJWWd3PPP2tfpyESYbbbGRFU6TmyM1TN3K/JNE65kZFw
	9tRrAxpu3OUDhHUaWvfjWZmT1uFYdXW+gqOOByZnzXYXSlRlVLcWZ0A/ZD0UyhLo1U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=alien8.de; s=alien8;
	t=1372837062; bh=UzAsjmBS+2S67wNsB0+/hm95uTWWHxMemA3v/enxcXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To; b=sqdibYcRh7JKxPIvGnlGltC04q21KnnwqXu2je
	U+ZWwRXlPlybU8F7cRfOqF8ZJWWd3PPP2tfpyESYbbbGRFU6TmyM1TN3K/JNE65kZFw
	9tRrAxpu3OUDhHUaWvfjWZmT1uFYdXW+gqOOByZnzXYXSlRlVLcWZ0A/ZD0UyhLo1U=
Content-Disposition: inline
In-Reply-To: <CAPXgP12AyogbFX_hPPmQD5GFG0-+_crsnHF3epDZSRds3-WNtQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mike Galbraith <bitbucket-BGeptl67XyCzQB+pC5nmwQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bsingharora <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dhaval.giani" <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, jpoimboe <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, workman-devel <workman-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 03, 2013 at 02:44:31AM +0200, Kay Sievers wrote:
> I don't think anybody needs your money.
> 
> But it's sure an improvement over last time when you wanted to use a
> "Kantholz" to make your statement.

Kantholz, frozen sharks, whatever helps get the real point across. Hint:
this is not at all about the money.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
