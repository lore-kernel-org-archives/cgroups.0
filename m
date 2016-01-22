From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-4.5-fixes] cpuset: make mm migration
 asynchronous
Date: Fri, 22 Jan 2016 10:22:32 -0500
Message-ID: <20160122152232.GB32380@htj.duckdns.org>
References: <56978452.6010606@de.ibm.com>
 <20160114195630.GA3520@mtj.duckdns.org>
 <5698A023.9070703@de.ibm.com>
 <20160115164023.GH3520@mtj.duckdns.org>
 <20160119171841.GP3520@mtj.duckdns.org>
 <56A23BA8.1040403@de.ibm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ZLzYqIFAUaY/N9g8vzH5R/O1UJj7SLAfZ0nMZmNjH+A=;
        b=mQhVn0AsHczULCEdFrBS+3mhJ8rnnLz4QQtZ4XSYQ6fey5VP9+h0J86hA5TngX7rHB
         0HhUhY+JQZAIYE3Z1T+kVBnf7kJ5kJ1yGaXMJ+YUH9zMgiUKsoJOev0lzdJWZAeSF3wS
         ZeHZRwMgNby3o5+T4jrV8Zvcx5zH1gE8OifMJAWnej1glI71AicZxeOe3P0UrplBmj6u
         yt6imdQo8DftTzkTqtOGQAMf/g/ajGZ9Gn+AUcp+3yPMiKYbrYdK4EJBz0GuoZ4r8B+3
         euRhpEZYiyzQXeFPMj2iLTqFDafde6g3nwF4PiCnh6G+mUXCgT0TS2ILdPuF/mPQxYWC
         yKhA==
Content-Disposition: inline
In-Reply-To: <56A23BA8.1040403@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, cgroups@vger.kernel.org, kernel-team@fb.com

Hello, Christian.

On Fri, Jan 22, 2016 at 03:24:40PM +0100, Christian Borntraeger wrote:
> Hmmm I just realized that this patch slightly differs from the one that
> I tested. Do we need a retest?

It should be fine but I'd appreciate if you can test it again.

Thanks.

-- 
tejun
