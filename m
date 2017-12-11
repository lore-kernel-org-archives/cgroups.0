From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [bug report] writeback: sync returns with dirty pages exist
Date: Mon, 11 Dec 2017 08:42:20 -0800
Message-ID: <20171211164220.GL2421075@devbig577.frc2.facebook.com>
References: <dc694ae2-f07f-61e1-7097-7c8411cee12d@gmail.com>
 <20171205182007.GV2421075@devbig577.frc2.facebook.com>
 <8844b550-d91c-38d5-997a-a899d1e4aa42@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=mC6jxHZWpD4LLr7Hogp1efHv84uynssp4CnhK/hDDi8=;
        b=lWktUpXYs5QRpZ9nwLQ4oSjWNqoaa4rjDvOVB3cHYajC50lv2+bbL5hegO5nYAWGDx
         wlrGCCeUQ4mNZBWp0dCIXOqZ4drafol+azwip+MKmuIE1IWbG1IT9pyVEEsSg04pe2z1
         HOOhWbZTHcKHXY8yhti4A0iBnGPO5rDviJm8qDP8faOCjp2YNUNNueZBvFjQP4M7o7s9
         HcE7nx0aiixlPmhfsX4p7s1/bYIYh9mPiJYWBvs6vXoWciMvMoDNR/pPIUTBEs4V840p
         UxbK8Dm3QOun3Sv5JpYorNWwYaAOTzaqeNDsQriaFO06RwnH/ujHylsopmDBPlQLVPYK
         CZ3Q==
Content-Disposition: inline
In-Reply-To: <8844b550-d91c-38d5-997a-a899d1e4aa42-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: xuejiufei <xuejiufei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Dec 06, 2017 at 09:37:03AM +0800, xuejiufei wrote:
> > So, wb_wait_for_completion() may end up returning earlier than
> > expected but data integrity is waited by wait_sb_inodes() which isn't
> > affected by inode cgroup wb migrations.  Have you actually seen this
> > happening?
> >=20
> Yes=EF=BC=8C I have seen it actually happening. I think wait_sb_inodes() =
only
> wait for pages tagged with PAGECACHE_TAG_WRITEBACK, that means it wait the
> pages written before. The pages are not written are still tagged with
> PAGECACHE_TAG_DIRTY and wait_sb_inodes() will not wait for them.

Ah, you're right.  Working on the fix.

Thanks.

--=20
tejun
