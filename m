From: Mike Danese <mikedanese-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: question about synchronizing cgroup_taskset_migrate
Date: Sat, 2 Jan 2016 16:09:13 -0800
Message-ID: <CAMu1AU4UcCVoKQ5MV-=0OHD7SkGAWeqN_CAEYEuFExvDF8XL7Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=+AzSrUP7hAEgC1k69KJvtnI9Xo2KTN2mmwzF8zFQSYs=;
        b=mVdHfsvv6H8hmF2fmzB8hIqIz6P34Mldc4oR59xRxGOwt1t70Gn1eLdO2z1E6kXdkk
         zOVTh3eN+bf3rHshd7jOtBBhXFHz8pE4lm4bYuWe80G01hSGjtXppgA3Ln3Uqx4+6oI1
         KoTcVbNeI4sC0rIsm7hTXouh4t1cf2J8UFkeoVjtoDLTy3nBakvVVrNhd/rwnGVghu6J
         abfn1X1kgBs4aXaDEqFy6wZFn8r/NJQwtlcw+x+EXPsh/Tuxid1tx7kd9XzQJ0x0KXXV
         HWHTELDOSPyhb2Yomc+hK9F/vPD026eZggWTwMo9BruGmwHAPpUr+KZdFeGJ34CqGwdd
         nqzA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

It seems like a lot could change betten css.can_attach and css.attach.
What guarantees that by the time attach is called that the can_attach
still holds? Are calls to cgroup_taskset_migrate serialized externally
or should this be managed insied the css? I see a note in
Documentations/cgroups/cgroups.txt that for can_attach cgroup_mutex
should be held by caller, so I assume the former but want to confirm.
