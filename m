From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v6 00/99] XArray version 6
Date: Thu, 18 Jan 2018 08:48:43 -0800
Message-ID: <20180118164843.GA23800@bombadil.infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
 <20180118160749.GP13726@twin.jikos.cz>
Mime-Version: 1.0
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=45OvbFjaC5ZtOW9Pf876j4SpLCoikypOTgeEj8Q5t4w=; b=g7zAvEbC5p5T5FdJbU0+/63v+
        vBmi0GWfPdT//EBu+DPSmytesFZjCOxV1QE9uSqnrDdNYPy1U3SQ8FhKV90mdI/vF4IxsORfIPPqk
        yFDR0Ep9PqbU+G5jvypnasrfbOERMj9GkpgZPqgsLTFmgUjItEQoc69iKwEUg3kDJy4cS0oZ4HJ81
        3AzQQi+aEibr7BlnRY/Ap+O+9eSBDSoktCz+hIC5+bg1+ZIHfWnQMsekn3m9C/2zO0je4JkQBOg0t
        CAja7baMZdliAP8m2LFrZZTDGl48HNxcnNhcsBYtS77XdxpVbmgSnlwZZwCjTf7zwES209V520TxF
    
Content-Disposition: inline
In-Reply-To: <20180118160749.GP13726-1ReQVI26iDCaZKY3DrU6dA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dsterba-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjorn Andersson <bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Jan 18, 2018 at 05:07:50PM +0100, David Sterba wrote:
> On Wed, Jan 17, 2018 at 12:20:24PM -0800, Matthew Wilcox wrote:
> > From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > 
> > This version of the XArray has no known bugs.
> 
> I've booted this patchset on 2 boxes, both had random problems during
> boot. On one I was not able to diagnose what went wrong. On the other
> one the system booted up to userspace and failed to set up networking.
> Serial console worked and the network service complained about wrong
> format of /usr/share/wicked/schema/team.xml . That's supposed to be a
> text file, though hexdump showed me lots of zeros. Trimmed output:
> 
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> (similar output here)
> *
> 00000a10  00 00 00 00 00 00 00 00  11 03 00 00 00 00 00 00  |................|
> 00000a20  20 8b 7f 01 00 00 00 00  a0 84 7d 01 00 00 00 00  | .........}.....|
> 00000a30  00 00 00 00 00 00 00 00  10 89 7f 01 00 00 00 00  |................|
> 00000a40  a0 84 7d 01 00 00 00 00  00 00 00 00 00 00 00 00  |..}.............|
> 00000a50  80 8a 7f 01 00 00 00 00  e0 cf 7d 01 00 00 00 00  |..........}.....|
> 00000a60  00 00 00 00 00 00 00 00  60 8a 7f 01 00 00 00 00  |........`.......|
> 00000a70  a0 84 7d 01 00 00 00 00  00 00 00 00 00 00 00 00  |..}.............|
> 00000a80  30 89 7f 01 00 00 00 00  a0 84 7d 01 00 00 00 00  |0.........}.....|
> 00000a90  00 00 00 00 00 00 00 00  60 f2 7f 01 00 00 00 00  |........`.......|
> 00000aa0  40 fd 7e 01 00 00 00 00  00 00 00 00 00 00 00 00  |@.~.............|
> 00000ab0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00001000  3e 0a 20 20 3c 2f 6d 65  74 68 6f 64 3e 0a 3c 2f  |>.  </method>.</|
> 00001010  73 65 72 76 69 63 65 3e  0a                       |service>.|
> 
> There's something at the end of the file that does look like a xml fragment.
> The file size is 4121. This looks to me like exactly the first page of the file
> was not read correctly.
> 
> The xml file is supposed to be read-only during startup, so there was no write
> in flight. 'rpm -Vv' reported only this file corrupted. Booting to other
> kernels was fine, network up, and the file was ok again. So the
> corruption happened only in memory, which leads me to conclusion that
> there is an unknown bug in your patchset.

Thank you!  I shall attempt to debug.  Was this with a btrfs root
filesystem?  I'm most suspicious of those patches right now, since they've
received next to no testing.  I'm going to put together a smaller patchset
which just does the page cache conversion and nothing else in the hope
that we can get that merged this year.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
