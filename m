From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement unified hierarchy, v2
Date: Wed, 23 Apr 2014 11:14:16 -0400
Message-ID: <20140423151416.GF4781@htj.dyndns.org>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=SyH46Ed4Rz0geEl1+i6r+1D+BRtjp0dga7f1GYC2NoU=;
	b=r2F6wFj5OthuLDiuD/pCBMpcjLZ9wj44s2dE7NfnWMldHbhW70txTbe4aAqIQrjszI
	A+feNYT0ktzhmiCEJ5WHb+jB8jDPhE2j0O/hu9kRHQPImWDZZ+vBj3jh/VFdOC+LMHjT
	mP/pB2OClDtmhoxuP6siIqDvcDRrjdGK40qU+qqueiN4XyMjwiMwWbvF+yTjRxrelLvB
	3g9yP5xZ2ibp5Fg26VLmVfcCjAx/Cbu7lpWRbr7qmSQVbL7bsH+Dd75EZWhhbFERJDhW
	Lj5TrrBwjzMsctTRMeL7o2yxTUTab7zcLZTOGsXvIM73SsdksJsubfYlQD+K208CPpVU
	d6Qw==
Content-Disposition: inline
In-Reply-To: <1397511430-2673-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Apr 14, 2014 at 05:36:58PM -0400, Tejun Heo wrote:
> Hello,
> 
> This is v2 of the unified hierarchy patchset.  Changes from v1[1] are,

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
