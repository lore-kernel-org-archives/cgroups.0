From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 11/19] kernel: convert cgroup_namespace.count from
 atomic_t to refcount_t
Date: Mon, 6 Mar 2017 14:55:58 -0500
Message-ID: <20170306195558.GE19696@htj.duckdns.org>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
 <1487585948-6401-12-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5MBlFUwJP9Ip1C25ge+H/ES33Dxr9fTyfom2WCtYVkg=;
        b=BWZwZQ1MeGfOq9P+udlPvEFfOlm9eN6c0/4FJ9oR5QwqivFZnbhR8dI5nALYiEcKGH
         MJyGSTfWWzgOZFMVWQjyXS3+oqb+dgBaTlkEAO03MbZfmcmaN5u2mmrONknjAPknW9G4
         vNfP2VyySyjVpde8VKZ9/WDYskB2F8uoQE3adBMj7HGMDzVWfvs/MTXLw5zhVoEOrayV
         kvDk/HJaRDDgrT8Dw92wLXSKrwOdDEwJJnUuelAq4rC9zPHhY4/HbCLb6KNMAbcoU9rh
         1a6scLPGsc0FYpNSK5O8pwEhuf1d8sdpvl5MN56Sh5uT1q1C2m69HwiIEJH7QqUfnCTG
         vX1Q==
Content-Disposition: inline
In-Reply-To: <1487585948-6401-12-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, paul@paul-moore.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

On Mon, Feb 20, 2017 at 12:19:00PM +0200, Elena Reshetova wrote:
> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.
> 
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: David Windsor <dwindsor@gmail.com>

Applied to cgroup/for-4.12.

Thanks.

-- 
tejun
