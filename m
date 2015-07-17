From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET v2 block/for-4.2/writeback] ext4: implement cgroup
 writeback support
Date: Fri, 17 Jul 2015 11:20:24 -0400
Message-ID: <20150717152024.GC15934@mtj.duckdns.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <20150712180520.GE18734@mtj.duckdns.org>
 <20150717013731.GF22531@thunk.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=uH6DtPmaHfqNIipmzC4GhPuxD1ZHZTK4WzOlRJWeBiQ=;
        b=nxZIzz1SVZH+6JLbM8a/EdPqrl6cNq6/dwhzyxphbfMZh4b6O5gxVC76iRNn44H+7x
         05sD0MgsdqSmcnnV8su+w330D5LhB8wOPWrgmunHS9nb8Zq5AUqbv9BcS1z/sQLE2Rcj
         7kfKr/XJYLNKQQLNgK/kxWboJ8mZX7wo8G6yiXeXKTY2lIS1ZYxorGreMQHAiZ99NfBH
         ugEb8f0pUmNVZeV47/JpEaZ+vBbHVhLVWmTWADm1kZ4UZArqpFzBDOBKZk6n452owL9e
         7SCoGR+qfpWO47MHvueQCUG4GdVgwulyRa8+AkhNeam926H5fCNJKRTbzirwvD4C+4TA
         eoqw==
Content-Disposition: inline
In-Reply-To: <20150717013731.GF22531@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org, kernel-team@fb.com, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org

On Thu, Jul 16, 2015 at 09:37:31PM -0400, Theodore Ts'o wrote:
> I'll take them through the ext4 tree.

Great, thanks!

-- 
tejun
