From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/2] decrement static keys on real destroy time
Date: Thu, 26 Apr 2012 15:32:14 -0700
Message-ID: <CAOS58YPKtZ-oLOtaNqgbxB4Nf0Vc=eL+FjgfMj4a9T0yjn57Sg@mail.gmail.com>
References: <1335475463-25167-1-git-send-email-glommer@parallels.com>
	<1335475463-25167-3-git-send-email-glommer@parallels.com>
	<20120426213916.GD27486@google.com>
	<4F99C50D.6070503@parallels.com>
	<20120426221324.GE27486@google.com>
	<4F99C980.3030801@parallels.com>
	<CAOS58YOKUq7GTTZRcw19dth+HgThoNTEcqBKeNO0ftB4rFJ97A@mail.gmail.com>
	<4F99CC17.4080006@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=Aw6Eirbr3fRYMHa7+6cSWrSsS0D/uaRJ77vyfC8DoaQ=;
        b=ozs2KMDKk9hi5eMwEM5tQoRPxv0RpdcrHOpW9lPf/SIwgvgkCqZ0gt/n5YWCOw31BY
         IPARiarbIA5QCtUWVkudo+PkaMPQ8axxsoRKJq/rZy8tW0WmlRkKmCGCvbmeai8i3rs0
         L0+3A2N0b52QYGDpoxmbVriM90yMWTCaefXHfJkkOSPaB2JX+Y5hS69O/nY8owJTjnHH
         Awnlwg8dyD70DXco+BpKDwOcY2803RuFrJvmqnjPKDCbSdeKQ+rt4nM5ssRTVtVaGW6b
         7sCj7PSoxOCKjrgsYNWxqZl2qhNPMYDDjWutv6y/JDn+ed6lgEz+AhbleeIzZ6qLcLmg
         lkZQ==
In-Reply-To: <4F99CC17.4080006-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Thu, Apr 26, 2012 at 3:28 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> We need a broader audience for this, but if I understand the interface
> right, those functions should not be called in fast paths at all (contrary
> to the static_branch tests)
>
> The static_branch tests can be called from irq context, so we can't just get
> rid of the atomic op and use the mutex everywhere, we'd have
> to live with both.
>
> I will repost this series, with some more people in the CC list.

Great, thanks!

-- 
tejun
