From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.12] cgroup: make cgroup_event specific
	to memcg
Date: Mon, 26 Aug 2013 11:17:47 -0400
Message-ID: <20130826151747.GD25171@htj.dyndns.org>
References: <1376582550-12548-1-git-send-email-tj@kernel.org>
	<20130826141536.GA14985@shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=ui+AtLUiVsp28/uAFliWuKGJGTxddmbxRmRmSWuuv+Y=;
	b=mtzN4B3raceBDYaUpjOj2CULgMgiuF4NuFr7bZpedyBmdnIY3VHhViCsrbhyKHRmSg
	VdDEZbxNHOoCyJAPj8DAVjIcSCilf0CatcL6nMTpQP+PJw/+HRpYTPIDKjBCogUbfj/Y
	QN2PW6h7hfMRuaIQFoyedU+PN2ZeOU23YsEv5vDwDtdHb1RM4UgbaSvXG6HqrtkMQmlG
	QW9NhnWXvRXliGJZ670nzQM8HVgoQBxl8U8O6RIPATjMmTvimK/rpnCR7gXj9KzwrTHX
	XyPSfHhYy3NMnVLkoO9Cx2SZBFGpGpjJf/hpzdl2h0crT8LoLtkOZ7Q8EkfoSFajlDVM
	ab/Q==
Content-Disposition: inline
In-Reply-To: <20130826141536.GA14985-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
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
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello,

On Mon, Aug 26, 2013 at 05:15:36PM +0300, Kirill A. Shutemov wrote:
> Few questions before I'll ack the patchset:
> What's the plan if we will need a similar capability in the future?

Just a normal file modified event.

> How would you implement memory thresholds today?

Ditto.  Just a normal file modified event when the threshold is
crossed.

Thanks.

-- 
tejun
