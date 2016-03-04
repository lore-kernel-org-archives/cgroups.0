From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: remove stale item in cgroup-v1 document INDEX
 file.
Date: Fri, 4 Mar 2016 08:05:43 -0500
Message-ID: <20160304130543.GA15458@htj.duckdns.org>
References: <CAFt=ROOuyaicfrRDnpJxMiB5Gedm-tzeNR0FOr24fPsPWwoH=Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=04fy2mLpWYRYv73JlW7pVEW+b5AgRgdVOJZW2+HYVbs=;
        b=MPXhQScvV8OI7FVFO9K2bSHMjiHCrb9qS+VxLxLjbfOUQ/cwir0JWlRCRrJsYvu9ZB
         Bwn0oOZ25LHgU2bAKcxtam21qwRX/JKyNHMPbxg4jGKuqhsiCAFykTzcfHlD2efJ2D4m
         OIIYjLEng/ydOr3gvN7RdzQUzO0vDVY5pTA/Bc0ufKJfsCzUtrkDUPCjkAkidLg0t8IK
         ekPOs05U85Ukzx7/kaM6jYg92pePO3e8tVfCmmCys0KUVFAp0KD1O1EDpEySatCzUuue
         h0JGwa2ZJtnMt/5XVxrfUgCOglzBTnpdDr+I3qpnbDI2ErRIFE3f3JLKEvz9BnsjzLe2
         o4sQ==
Content-Disposition: inline
In-Reply-To: <CAFt=ROOuyaicfrRDnpJxMiB5Gedm-tzeNR0FOr24fPsPWwoH=Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: haosdent <haosdent@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello, Haosdent.

Applied the patch to cgroup/for-4.6 but a couple things.

1. It probably would be better to use full name in your from address
   or put an explicit From: header as that's what ends up as the
   commit author.  I hand edited it this time.

2. The patch is mime-encoded and whitespace damaged (taps replaced
   with spaces) and didn't apply.  Please make sure your email is
   setup for sending out patches.

Thanks.

-- 
tejun
