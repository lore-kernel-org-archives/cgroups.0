From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Why does devices cgroup check for CAP_SYS_ADMIN explicitly?
Date: Mon, 5 Nov 2012 18:38:45 -0800
Message-ID: <20121106023845.GI19354@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=TI6h2GoVrVbDqmDjIoNS+TFhdhQDBJO35CdgM7v8huw=;
        b=hUEa5uCg0nTGkw4QmY0qv94k0ojQTsWvjkt350Y+6BJcMGH2AOXzV0SgfseEOnfO3B
         Qkklh8v/QBqI8aC93N8ezektU41Lw+5qy6F9c4knjQPm0AHPZKiHSDNcAFx6XShELZFQ
         wVhDuuaUkrKKoqjN7hEMEmCAV/rL7MHLJXQyuXHnwmQ9UGjiQ0m9o66E1FNJ2zqXyq3V
         3nv9ip+Ma17RvKWf3GOxHt3nWTT5OQr/D5kR+ml6e0rB8l0GJAn/rwLEBDYKSR2DT/Bh
         hbvXvZg4+fRDSdx4tJPfskrf8f2Y55kiLEQP/WLGdX/hgKLUZI7V96vT8c0zxlwZI2gc
         PAPg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, guys.

Why doesn't it follow the usual security enforced by cgroupfs
permissions?  Why is the explicit check necessary?

Thanks.

-- 
tejun
