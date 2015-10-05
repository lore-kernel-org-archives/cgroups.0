From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: pids controller fails to track zombie processes
Date: Mon, 5 Oct 2015 14:09:19 -0400
Message-ID: <20151005180919.GC11164@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=ZexWMma60G25kOgg8dk6p3Ymd4k870/Rx1PklFUovTI=;
        b=NlETSv6gZle8VWOKGN8H8oFzSoANKdzyQLn6LR6ZJvJ71dh6wmRNNgJplVhAhM8MXY
         TQAIfo1qx3lJ7+4aCxPcAfTB9yTmw35vhtTItlJzv2BwXqXHsG1IDdTRx6hHtOkcreJ4
         GPvzTZW0d0x2Q/YWbApd20Yg1Ebcq5soi1KMhBn6zmRllNstJj7E76GWRjuhgglz4gyg
         mHv0CgWdrXwZi49oAOtiWiR8cj3th4s9jj20c01DIMlaVZHuFBl0sFZSgjSDAbQujIGY
         5ps3kRIHTKxHKormMD/erg5XxReGtAgmAme7lnCEFyChu0TKtriDj48puXBCQKAk+Wah
         gONw==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Aleksa.

I noticed that the pids controller is uncharging from the task exit
path; however, this isn't correct as zombie processes can linger on
way after exit while holding pids.  I can't think of a good solution
right now.  I'll write again when I know more.

Thanks.

-- 
tejun
