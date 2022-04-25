From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/5] cgroup: Adding
 test_cpucg_nested_weight_overprovisioned() testcase
Date: Mon, 25 Apr 2022 07:28:17 -1000
Message-ID: <YmbaMZfBJp3Ngd/6@slm.duckdns.org>
References: <20220423123053.2982931-1-void@manifault.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5PTbB51BgaGPargq7ZsmCLhWUmXSpuGaWJQBYhiIAqM=;
        b=jfEQSXCifXo8CbMxyMkfZLGgdeAPSaigLwoXp5yW++2rRa9M5CmBL6z6FWKIBm47C3
         yVYrHOs7mVmpSyk81b4oQpjc7OsAX6tFMawE2QyyY4izvbg93Q/0KA1MTtMc9DkFe+73
         7WIVoPtDV8EhN1cmZlcpo3cyPw6p/nxOz+v0jVHqdGYvgbr+14qeU/9/VQQaGeEgiM1N
         riZww7vzL9oSM3ttxkEVOFHU8QL0ZRdko+qQecaPJg1SFgGCG/pJGy5aEdH+wzF/z7oU
         0wEASrUuazY1kNpifl7RJudbG3ZnWraPZx00vMM6Wr8gcCpfmZHqE6+wS+7GtLjJSDeN
         1zCQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220423123053.2982931-1-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sat, Apr 23, 2022 at 05:30:50AM -0700, David Vernet wrote:
> The cgroup cpu controller tests in
> tools/testing/selftests/cgroup/test_cpu.c have some testcases that validate
> the expected behavior of setting cpu.weight on cgroups, and then hogging
> CPUs. What is still missing from the suite is a testcase that validates
> nested cgroups. This patch adds test_cpucg_nested_weight_overprovisioned(),
> which validates that a parent's cpu.weight will override its children if
> they overcommit a host, and properly protect any sibling groups of that
> parent.
> 
> Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>

Applied 1-5 to cgroup/for-5.19.

Thanks.

-- 
tejun
