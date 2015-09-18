From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] cgroup: use static_keys for subsystem enabled and
 on_dfl tests
Date: Fri, 18 Sep 2015 11:55:51 -0400
Message-ID: <20150918155551.GB4065@mtj.duckdns.org>
References: <1442368285-16306-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Umu7z5SXoWm/Sg6WqY2wl17yRZjRdW4ErdpC/jCKcNw=;
        b=g+SCUqqVUXPemraMktkPsrU0vwaPuZOgazg2MsMRqPMhTstngaMfuFg3lwQ5mNUODg
         /3KEwm9Rb2oTBKB3jCeqVnDD3mH34G8NSJalW8tmaYTsnmLxlI/WSTazUAwlmZVNJ4KY
         EBDck5uh88EFd00zDp5Ae23XkvRCHcQ5Xo8QK3DGR7UMRQjbC/yq+srocbkjr+hJv6GV
         +IKrCJ7HstZFFuUvUl0nzzskv5AlmAdIcdA/+Izykt15/wnQcQ+6xuJ6G4MBpTLgV3b6
         3BBzDuo0ONPcw4w8M0skopjW39S0KdXYrD9tkOC0g7rB8IAQi/uDe5M6LlsE/pziC8S2
         HYYA==
Content-Disposition: inline
In-Reply-To: <1442368285-16306-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Sep 15, 2015 at 09:51:21PM -0400, Tejun Heo wrote:
> cgroup_subsys->disabled and cgroup_on_dfl() tests are likely to be
> used in hot paths and seldom change.  The former is set once during
> boot and the latter only when a controller is migrated between the
> default hierarchy and traditional ones.

Applying to cgroup/for-4.4.

Thanks.

-- 
tejun
