From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup, docs: document cgroup v2 device controller
Date: Wed, 13 Dec 2017 12:55:53 -0800
Message-ID: <20171213205553.GW3919388@devbig577.frc2.facebook.com>
References: <20171213194903.1265-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rfw1ZD3MteFV73YZNl1Spqd56GGPRMXhXtm1t9KxM+8=;
        b=rF3fPOjYmOh/W71znuQYAtjTZos3m6+FsmNcHJvFUgSsSnzE/9szTtxK5wH2GAFbcB
         SA7glvZxciX/gzWBfQltuJOHacpofSPx6MaSEbYTJth7mvikNUJ7nAURcuWhJlBcfAUI
         6/Y5ONZcj5GGaSAoHy6IUvEvr7jXmZOblqIDh0r6wf1BraZDzWFTcRe/vhXnv2zcuS7A
         Ig9ou5Po4ozAPbMVZV3Qs78aVoBTj5wmOm0pcmQ4LXu4ewNozwHu7TsofTOlQJC7PYvg
         gVIcsP6QALOiReTCOSEdVyrIXyqIDGHMYp+McTPpnakVfpEi2sKtsbpW8SVEDtR32+ca
         B91Q==
Content-Disposition: inline
In-Reply-To: <20171213194903.1265-1-guro@fb.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Dec 13, 2017 at 07:49:03PM +0000, Roman Gushchin wrote:
> Add the corresponding section in cgroup v2 documentation.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: kernel-team@fb.com
> Cc: cgroups@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Applied to cgroup/for-4.16.

Thanks.

-- 
tejun
