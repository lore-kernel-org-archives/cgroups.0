From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET cgroup/for-4.4] cgroup: make zombies retain cgroup
 membership and fix pids controller
Date: Wed, 14 Oct 2015 21:38:09 -0400
Message-ID: <20151015013809.GC20884@htj.duckdns.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4m7uuSMSPj/9QvdnrbWmYdB449YyUjMyZQ+fbULlz5g=;
        b=x1MteYV+kGCahTI1/Nu64qTXbg9thqf20FuaOt1u6rMhOLiFFDCk/MhOzPwVWs2sEw
         Wj4thOZS8R1EUhyaAllOlmuj4P7W09iHfvrRNLFIlS45lGPSyyY9rFhUwxmMvZa31baO
         Db0Adz81lkoCHbzvRs29IyVqu+0nYxoXw8+XnV5E25P4ZHSImDklE2XJLBDkFySc0meC
         52PJZRpaLvl8SLp5oYmpYaJLmnT4dpLf3FFVrp9BcFrT99ekACbfERTEKaxF7cdNFpCE
         oeFpxlHkhtIJpbXrFztSSoO20J6XJdYCAeoH5ESD88E7FBVTH+B2+D1iEsdEsLdclwT7
         EwnA==
Content-Disposition: inline
In-Reply-To: <1444447781-16182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, cyphar@cyphar.com, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hello,

On Fri, Oct 09, 2015 at 11:29:27PM -0400, Tejun Heo wrote:
> The patchset is pretty lightly tested and I need to verify that the
> corner cases behave as expected.

Fixed several bugs while testing.  Updated patches posted.  Seems to
work fine now.  git branch has been refreshed with the updated
patches.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-zombies

Li, can you please go over the changes?

Thanks.

-- 
tejun
