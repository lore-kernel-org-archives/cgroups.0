From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] docs: cgroup-v1: Document the cpuset_v2_mode mount
 option
Date: Fri, 3 Apr 2020 11:43:43 -0400
Message-ID: <20200403154343.GE162390@mtj.duckdns.org>
References: <20200330140615.25549-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vMx0MOLe0yvwgWuw4zcBKaQIRZC+xinekU6xHhikY6Y=;
        b=lLOBh+umo7XmD7bXXEWTjIKbErh0pNJ4W1cHP9XwA6Q/F75wkb7gFTSXpXMNV294+M
         Vwr/9u9w4YVoFzulwd8BEeyHuQ8kMIAMYrQMPKTMpXaKlFHkDZ7Hm6YJ8zGjpJfpBeWL
         sm2CLEazw1xhEEJ1vv6N8KbYOmwQOSaJC/xpscVDIULWN8lfy96+Lbuu1iGvXIB7CrA3
         lpiCY9kilSUJfP2kaS6kk+z8oXKGdFjTV1CKWpCAiQA1VZhzReL4UpiC1v3jI87qOqPs
         yrxm6+S6HCShyMOPfFjuldMpPZEjW7L+qVrB9nPI28ZkTo3OsMtNIscZjXfcVE3mJEL3
         X3zQ==
Content-Disposition: inline
In-Reply-To: <20200330140615.25549-1-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Joel Fernandes <joel@joelfernandes.org>, Sonny Rao <sonnyrao@google.com>

On Mon, Mar 30, 2020 at 10:06:15AM -0400, Waiman Long wrote:
> The cpuset in cgroup v1 accepts a special "cpuset_v2_mode" mount
> option that make cpuset.cpus and cpuset.mems behave more like those in
> cgroup v2.  Document it to make other people more aware of this feature
> that can be useful in some circumstances.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Applied to cgroup/for-5.7.

Thanks.

-- 
tejun
