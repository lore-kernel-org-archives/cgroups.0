From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: question about cgroupv2
Date: Mon, 20 Jun 2016 14:19:29 -0400
Message-ID: <20160620181929.GN3262@mtj.duckdns.org>
References: <5764ADC5.20205@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8i/8XCjZvDeFdKWMARWYaSK6RvFOPN2Qjh98esRzZYY=;
        b=eprUNIBQagfI5ff1Re3jxmB/5updbnCKNw3eUNSx1Z21G7xeWT/TpRzursRK4H654q
         d3sYlvv2dq6lYrm508UDOiDhxZstmEkKDGvbcs1XmX3nx91Vilh0Z7RCgr8vovUdPgX1
         jD1mlOFiXsd24qf7tjvOoY+6HuUi69SP/dgblTRTtkfA7vU1gi1glQy2P+8YIH0HOBch
         xZ7nWUBtT1i0FXI5Kil+TjbJ5gAmlwpZXvfNeA8vKne5BZoSsSWvcyTqdw1oL6Ag+L4k
         4FwHSmnBfOrrnUMiseV5+/VTMSX6uGxRXCIhv1/qh7V7pS8IVDUPhcmORagk91SoPNh1
         tZnQ==
Content-Disposition: inline
In-Reply-To: <5764ADC5.20205-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Sat, Jun 18, 2016 at 10:11:17AM +0800, Ma Shimiao wrote:
> I want to test how to use cgroup v2 on kernel 4.6.2.
> And I have read https://www.kernel.org/doc/Documentation/cgroup-v2.txt
> According to the above document, I added kernel parameter cgroup_no_v1=1.
> But, system still automount the v1 cgroup.
> Then, I executed:
> # mount -t cgroup2 none /mnt
> 
> But, cgroup.controllers in /mnt is empty.
> 
> I'm not sure if I made something wrong or cgroup v2 is not supported on kernel 4.6.2?

It should work.  Can you post the outputs of "dmesg" and "cat /proc/cgroups"?

Thanks.

-- 
tejun
