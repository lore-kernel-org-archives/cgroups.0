From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup.c: Use built-in RCU list checking
Date: Wed, 12 Feb 2020 17:12:49 -0500
Message-ID: <20200212221249.GJ80993@mtj.thefacebook.com>
References: <20200118031051.28776-1-madhuparnabhowmik10@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=htZSNJ3oIZAPreJh5xh8HpLPmxowkMMDY5AHwsIFPU4=;
        b=JgbLnHXZBEJ6fny9Cf39uzWywqhTZCEc9XA7HjonBYcbbBVxey3E8jGB1bPKWVrUdH
         MDi2aKPGMfYktEAwxum6w8vAcuQKbRKfvpUwLIGwLk3/YmeHtcygHekDiNYf5+9Q3/ti
         zacH6LhE208pGea8c9ESgsdYtAeXB4ezKvDfBqcv9jlPHtgoFYltXKi/V/yrcVbYwnku
         X3bNAPwE8YMLtOxeeS52qw2JNI4UFj3sP6w3f4vVctpZ6uj6fLe0Dq1xLddiXOyyjYKa
         A7dAQszw4h0EP/fqdq1NQXGkBCDWNQkAIM2qeUiWaw6Udu9cErLrvXzo/wABUaU4uD/W
         FynQ==
Content-Disposition: inline
In-Reply-To: <20200118031051.28776-1-madhuparnabhowmik10@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: madhuparnabhowmik10@gmail.com
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, joel@joelfernandes.org, rcu@vger.kernel.org, frextrite@gmail.com

On Sat, Jan 18, 2020 at 08:40:51AM +0530, madhuparnabhowmik10@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> list_for_each_entry_rcu has built-in RCU and lock checking.
> Pass cond argument to list_for_each_entry_rcu() to silence
> false lockdep warning when  CONFIG_PROVE_RCU_LIST is enabled
> by default.
> 
> Even though the function css_next_child() already checks if
> cgroup_mutex or rcu_read_lock() is held using
> cgroup_assert_mutex_or_rcu_locked(), there is a need to pass
> cond to list_for_each_entry_rcu() to avoid false positive
> lockdep warning.
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

Applied to cgroup/for-5.7.

Thanks.

-- 
tejun
