From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v4
Date: Fri, 21 Jul 2017 11:18:33 -0400
Message-ID: <20170721151833.GA3329631@devbig577.frc2.facebook.com>
References: <20170719194439.2915602-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Or30D7U6GafG4bJ6uDqI1BGLILNqvDb8WJzxT/pmlWI=;
        b=PHYYJOoWc5QSDOKJYN2498xXeAgZ1N86rp3qTaOdcR79e3vcnDNAoYXTE87DnTs5vg
         4lyBMn8EkM1owSaiGBaig+X9n7mV7BM8qk/TQOhF9fTP8d9hbGK500LZPsMH3eEgZ2Rk
         PSeC6FJv/HaxpubuNQUZ8lVS/3Au3bqBvvU7QYCArZ4xR7+PkRNGW/0ndQlnkyA3GS18
         2uPB+qd3+LMiTJgW+4bY+SG8T4juBTKZfS0qdLd5MfvXMQxw7xFSCOW/R1k7vdjjHO0s
         IF2Az35QHMjKeSba7u17GXrhBEd/KucxUq0ewHlSyxFt8q4ufcyVS6cxnSGUojFLpb/p
         Kv5A==
Content-Disposition: inline
In-Reply-To: <20170719194439.2915602-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

Applied to cgroup/for-4.14.

Thanks.

-- 
tejun
