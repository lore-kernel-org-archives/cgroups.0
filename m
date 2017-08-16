From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET for-4.14] cgroup, sched: cgroup2 basic resource
 accounting
Date: Wed, 16 Aug 2017 11:52:41 -0700
Message-ID: <20170816185241.GF4087514@devbig577.frc2.facebook.com>
References: <20170811163754.3939102-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iMz40AVW17GDnys/lIz2uLjJk+LVPSfUIWxMt7yqRqg=;
        b=EnT3B4BHwWeny8eNxP7ef+5hDhSR0TgeGADXuuM2RZs4fTYV9CvfkX0vNXlUct68KD
         H/Ci78qiOPq59jis+kbc99DwzH/i8OMzN9mI+Agn0H5NJ8v/LTJSRXhWgy0XkhxxKGKI
         4DMSa7OffTjxHDsUrKiqMfu11Rg21qp2EtxbTVS0Ezs3HodJbs2bkD9iNO9AcqLYo0EO
         S2f2GKpvO721g17EskmZN/BI2Sl4394xON0YR6oxM3zFUZ219VKDFkgofWPlYXPs8/vo
         LsLF4UR4vylnaMymvUJQ1rnn9sg4W6dIBaMsUGB380GskuZX8OAJD+1LX7h+dOfyArJk
         V8og==
Content-Disposition: inline
In-Reply-To: <20170811163754.3939102-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

Hello,

On Fri, Aug 11, 2017 at 09:37:51AM -0700, Tejun Heo wrote:
> This patchset implement cgroup2 basic resource accounting and track
> CPU usages on all cgroups by default.

Ping.  I've renamed as Waiman suggested.  If there's no further
objection, how should we route these patches and the following cpu
cgroup2 interface patch?

Thanks.

-- 
tejun
