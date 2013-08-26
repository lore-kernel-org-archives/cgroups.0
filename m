From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.12] cgroup: make cgroup_event specific
 to memcg
Date: Mon, 26 Aug 2013 11:30:28 -0400
Message-ID: <20130826153028.GE25171@htj.dyndns.org>
References: <1376582550-12548-1-git-send-email-tj@kernel.org>
 <20130826141536.GA14985@shutemov.name>
 <20130826151747.GD25171@htj.dyndns.org>
 <20130826142918.GB14985@shutemov.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=R3VbM9X+AKxslMYoKJTDmWJ2zb92xV7LKkwtuZlDFo8=;
        b=rDz/aSJSusWGM4YxVdYcDxcaRsKGLyoA/FHknkS+p1MxwkuC9n8o5qr1BpeB3R479I
         Zbk9MIuSMXhz1hTTNw/GZAy1Sm7dhBNSigq3ZK5wlSGYcb78i0iiOkerfilUZtOz5foq
         pBaKJKvcmp0mwEmLSfXw1fVnpNt0eXDYhlh1wxykPJFLQlL5H5mEudlgKDXsRVtATUrT
         sju1j7iQJk7KzIscAdu3UfCrc7lQcnvJUx3ToItkrGS8YkcAUdlGO53ctSduknGZ8gHP
         7Pl9mwdOyC9vaTHhXpz9YmVOz8D3Rcw5xRCJ1K7A6cY3XlsyQWelS3196QCzQDk3OiCn
         4Edg==
Content-Disposition: inline
In-Reply-To: <20130826142918.GB14985-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello,

On Mon, Aug 26, 2013 at 05:29:18PM +0300, Kirill A. Shutemov wrote:
> What about setting threshold itself? Do we a way to set it in inotify
> interface or you have something else in mind?

Just have another file which configs the thresholds or sets the
cadence?  The whole thing is overdesigned because it wants to allow
individual listeners to have separate configurations which may be
useful if access to sysfs hierarchy is open to everybody but that's
not gonna be the case anymore and configuration of sysfs hierarchy is
gonna be centralized anyway, so centralizing config of thresholds
isn't any different from any other knobs.

Thanks.

-- 
tejun
