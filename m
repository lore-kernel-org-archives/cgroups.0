From: Tejun Heo <tj@kernel.org>
Subject: Re: [regression] cpuset: offlined CPUs removed from affinity masks
Date: Wed, 19 Feb 2020 10:52:02 -0500
Message-ID: <20200219155202.GE698990@mtj.thefacebook.com>
References: <1251528473.590671.1579196495905.JavaMail.zimbra@efficios.com>
 <1317969050.4131.1581955387909.JavaMail.zimbra@efficios.com>
 <20200219151922.GB698990@mtj.thefacebook.com>
 <1589496945.670.1582126985824.JavaMail.zimbra@efficios.com>
 <20200219154740.GD698990@mtj.thefacebook.com>
 <59426509.702.1582127435733.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fFVDMYCiG2Jj7QSlhcVZE7ZVXQws5yCHBTafyc8gAf0=;
        b=Qkf7uJ1c4rV5Qm1v9FuRvQTyPOE0LdHlD1+++LZmhiqhFLAYLJCJQYulwn5mGbVQSQ
         b93pgugYT/+zQWagehceyEAvjfr1/EXp/YZpqn3v0IJ1ru89mZ3VSjJS6GRX/FI9LJCe
         XB0ajQwGjX/snUDFYuq61rJEPhUPxutyuiw8s3DOs6i/EgCsMkd4HnJsxkztYM9Me6sx
         9o5BLcIFLyBJNWmV3BNFtO7yrg1L1MEmQ31pETajfSjjFWOV9MPZ54G3lgfVDbpSuNWK
         DqTsVYB/R3ez5ZLWy+GAX7MGLOc4sP/o+7xmXydKDgRpRW3B24yugdxMlZlSWMa/UEEc
         BdOQ==
Content-Disposition: inline
In-Reply-To: <59426509.702.1582127435733.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Li Zefan <lizefan@huawei.com>, cgroups <cgroups@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Valentin Schneider <valentin.schneider@arm.com>

On Wed, Feb 19, 2020 at 10:50:35AM -0500, Mathieu Desnoyers wrote:
> I can look into figuring out the commit introducing this issue, which I
> suspect will be close to the introduction of CONFIG_CPUSET into the
> kernel (which was ages ago). I'll check and let you know.

Oh, yeah, I'm pretty sure it goes way back. I don't think tracking
that down would be necessary. I was just wondering whether it was a
recent change because you said it was a regression.

-- 
tejun
