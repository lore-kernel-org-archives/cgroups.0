From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/5] Update of Documentation/cgroups/00-INDEX
Date: Mon, 5 Jan 2015 09:20:01 -0500
Message-ID: <20150105142001.GJ15833@htj.dyndns.org>
References: <1419582386-5795-1-git-send-email-henrik@austad.us>
 <1419582386-5795-5-git-send-email-henrik@austad.us>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=omcseGOlW1N9gqDrpbsOQXYg45+LDrjn+1Uv1YSXgWk=;
        b=d6Iu422tXJYUdve8D9baw7cAFUfkjF1ZyIXKyfYqf4jfX6qvF1NJkQG0Jk5nGZPDcR
         BsrJqbMTuQVszTIzCBKrKG/rkRu+T996gt3uL9KMDkcx07AFWIuEFj4CCEMFYeXBCf91
         aOsOx8cJ/zXh5rVVmknQ9gsMVJHyC3qCGNo2zkrx04Y7P/Kiy+nv7+S/EiSfmhzvHCdW
         mg+2LhgOpTBDlbD3Dn5Pvy+0UsYOE+HNlA0LuSce8PP/llmIvGT3VroXUwMhRpCM524I
         6Eb8wYPwoT8EhxlZDgWkpbdygiJ4D0CZxetJcSPV+QKcsD4wnWQYo+C/+OyMR+mTWDzM
         5GTQ==
Content-Disposition: inline
In-Reply-To: <1419582386-5795-5-git-send-email-henrik@austad.us>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Henrik Austad <henrik@austad.us>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Fri, Dec 26, 2014 at 09:26:25AM +0100, Henrik Austad wrote:
> unified-hierarchy.txt was added by 65731578 (cgroup: add documentation
> about unified hierarchy)
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: cgroups@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Henrik Austad <henrik@austad.us>

Applied to cgroup/for-3.20.

Thanks.

-- 
tejun
