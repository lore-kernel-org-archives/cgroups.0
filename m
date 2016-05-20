From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 0/2] cgroup: allow management of subtrees by new
 cgroup namespaces
Date: Fri, 20 May 2016 08:22:44 -0700
Message-ID: <20160520152244.GB5632@htj.duckdns.org>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
 <573F23D0.2030500@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=znEGiDq68eKmEhQ/dkHwAPB+hMnq7WsS2qW6P8t29Yo=;
        b=rbHnASE/UiDkj6miAyq3qYopIUAdWmlBOzBUR+WSmknY53Offundyy5VZVLXA5yblb
         J1D0kmx6SPZFmW+CfB7Aa02BZv4QMZ33CXiqq5TNgswcOUK+LCaWSlfhNHpkWTBiNb6r
         iTRmqp0YNr+e/y2a1NXGUwivAD52faEmVCLIs8rl1TZigHEvQ5GFR0je/7ShA1v64f4q
         zGGlYZv7gEFhIPzT51276qIaeNBIoS3b6VmZdbo/K1RgKnClDbdYsiOqCRZMobQqrE18
         f/A90BDV9AA58aDAiW8ik+UahYH80YrP4wVUZdNGNN+iCOMK/HsKyJx33nHp+g4+Plld
         HKqg==
Content-Disposition: inline
In-Reply-To: <573F23D0.2030500-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

On Sat, May 21, 2016 at 12:48:48AM +1000, Aleksa Sarai wrote:
> Are there any comments on this version of the patchset? I thought we had
> reached an agreement that the underlying feature (allowing a process to
> manage its own cgroups) was useful. Is there a better way of solving this
> problem, that I don't know of?

I still don't see why this is necessary.  Delegation is done through
chmodding.  There's no reason to deviate for namespaces.

Thanks.

-- 
tejun
