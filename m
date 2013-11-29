From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup-for-3.14] cgroup: restructure pidlist handling
Date: Fri, 29 Nov 2013 10:46:21 -0500
Message-ID: <20131129154621.GF3717@htj.dyndns.org>
References: <1385331096-7918-1-git-send-email-tj@kernel.org>
	<5297E7E2.8080404@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=vMITtW2MhUdDewk0vClWBH9h3BN/RJph5kwJz0MQDLs=;
	b=pvHUDL7kayk0/1XmfJOTfQVAIQxA+SlFap/FRQsaCJoe9li658BALBaxERPMbln45Y
	Y04hVcwenSg6aKxR3yXFp/qO57wSgeCUYp6iBFv5YDVvw4gHWabuF3x5MPn70UxcbMX4
	3ch6FHPNrpNmLvs/b00PEX5EOzxf0L1Vu/TK4FzccRunLW4i42Ag2gAYu8nEtXFNzBEy
	2yzn/OAV/Cv05nWvX+oPPetTzKFceAKWhwjhiAhbQXQH6VpIdMa3I1WrwfEJz8LhlZfh
	PGCRBTvcmFsXXv64XRKzJq7aJBQiMbC1MQA0a4ViBT9qyZjO+3FETIyvBFVGeEuQwS8A
	qLyg==
Content-Disposition: inline
In-Reply-To: <5297E7E2.8080404-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Fri, Nov 29, 2013 at 09:03:30AM +0800, Li Zefan wrote:
> 
> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.14 with the v2 updates applied.

Thanks.

-- 
tejun
