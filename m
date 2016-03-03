From: Tejun Heo <tj@kernel.org>
Subject: Re: [cgroup/for-4.6 1/2] cgroup: re-hash init_css_set after
 subsystems are initialized
Date: Thu, 3 Mar 2016 09:59:45 -0500
Message-ID: <20160303145945.GE11029@mtj.duckdns.org>
References: <20160302180712.GA11029@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HEsFXDI2yIdzJltCpGQ2xNMtLq2Ptwh2CTFOBuUof/o=;
        b=DJPUTo2byMbjdbj0Ypac73O8KD99Od+Ro725jPFmpKbmmpfRsxEb/+a7sKrw+JNvDy
         Ppm2tFwrHXONydndiBsXguBu6GSxylgaGV9YGWNKbbJLyVyd6/b39laN4jz2y36O0hN3
         cgADeMCYPg1+cqRp+MjNtvFcWtWY8vuS53MBl8Y0vThOK386vz/j5ulcWLqd/680lLJa
         pnP9hvEFefipVtm4vdUAevpL1rf/jc8ylDYMxQxykMH0w0KieU5Uv0bQ/4rgA9N3LDc7
         0Lw9nMBPDEmrhBK6h+baDw2X7KGoYj0NGb18u3S1ZYZ0g/kAdpdQ5x97hv+IpT2BhquF
         m0Dw==
Content-Disposition: inline
In-Reply-To: <20160302180712.GA11029@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Applied to cgroup/for-4.6.

Thanks.

-- 
tejun
