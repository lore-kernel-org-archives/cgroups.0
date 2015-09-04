From: "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: __blkg_lookup oops with 4.2-rcX
Date: Fri, 4 Sep 2015 21:42:44 +0100
Message-ID: <20150904204244.GQ29283@redhat.com>
References: <CA+5PVA5rzQ0s4723n5rHBcxQa9t0cW8BPPBekr_9aMRoWt2aYg@mail.gmail.com>
 <20150902145307.GG22326@mtj.duckdns.org>
 <20150902153255.GH22326@mtj.duckdns.org>
 <20150904104602.GN29283@redhat.com>
 <20150904171302.GE25329@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150904171302.GE25329-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, msnitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Sep 04, 2015 at 01:13:02PM -0400, Tejun Heo wrote:
> The only struct which is large enough for 0xbb8 offset is
> request_queue.  Hmm.... can you please try the brute force debug patch
> below and report the kernel log after the crash?

So the good(?) news is this bug is not reproducible with the Fedora
kernel 4.3.0-0.rc0.git7.1.fc24.x86_64 (tested both with and without
your patch).

I'll keep it running overnight just in case ..

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org
