From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4] cgroup: Add pids controller event when fork fails
 because of pid limit
Date: Tue, 21 Jun 2016 14:06:29 -0400
Message-ID: <20160621180629.GN3262@mtj.duckdns.org>
References: <20160621172832.GM3262@mtj.duckdns.org>
 <1466531090-3539070-1-git-send-email-kennyyu@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YJwzLCGjJYEHJgYPNhJlzpEIuPzxvNYAn8HfJ/AvDNs=;
        b=omCvQ8KeIBHJqaJop4sEZX7LM3OELkAxksyZb0SORBxBls8BCVU1/3BltpRvIfIvNQ
         MmCEXbTJoqSe80JAWqEhvYI992F/lxRQOVW30WD95L3XPB+VFfAZ1EBnVFtFe4z4ONOV
         Ff36UeOSgRovlGJ9J67CZVRSkA8R6I6q3QSehmys1AQHsdvUBLXNryfc3bK2wzJp90qK
         WZmd+uZZJPxRGw+Vc6n0uLuDzdAIgBQu5exzBXzpBOZPT98q4/24Wca2fIVpdb6lPRgf
         88dlVf4K9lN9UYGLZ2WeGOEYHJDVmflNp/O2pHRj7BoV8lWynZmzIjxTs3ow+PYq97M7
         YQnA==
Content-Disposition: inline
In-Reply-To: <1466531090-3539070-1-git-send-email-kennyyu@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Yu <kennyyu@fb.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cyphar@cyphar.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Jun 21, 2016 at 10:44:50AM -0700, Kenny Yu wrote:
> This patch adds more visibility into the pids controller when the controller
> rejects a fork request. Whenever fork fails because the limit on the number of
> pids in the cgroup is reached, the controller will log this and also notify the
> newly added cgroups events file. The `max` key in the events file represents
> the number of times fork failed because of the pids controller.
> 
> This change also logs only the first time the `max` event counter is
> incremented. This is to provide a hint to the user to understand why fork
> failed, as users are not yet used to seeing fork failures because of the
> pids controller.
> 
> Signed-off-by: Kenny Yu <kennyyu@fb.com>
> Acked-by: Johannes Weiner <hannes <at> cmpxchg.org>

Applied to cgroup/for-4.8.  Thanks!

-- 
tejun
