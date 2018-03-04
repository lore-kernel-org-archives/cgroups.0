From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH V1 01/12] audit: add container id
Date: Sun, 4 Mar 2018 10:01:43 -0500
Message-ID: <CAHC9VhQA23w39aaho1wkPawX7zxiGyTVQroZzpACKk8DK8-F8w@mail.gmail.com>
References: <cover.1519930146.git.rgb@redhat.com>
	<2e5d93ee46feca915a101c2fc3062da674a98223.1519930146.git.rgb@redhat.com>
	<20180303091913.GA13118@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:in-reply-to:references:from:date:message-id:subject:to
	:cc; bh=IoAVZ7eE9jTD16oiKT5ycLhbuokBJJHSyK/rRofxlwo=;
	b=fuOIBeKFYyCi/gfYw2Q1E+8NselZNGOzHGZfVCamXQt86TavhO7fr4D2lZfXmyS+5a
	XLv4INVcusDFA9B/Ykv1ug+3liq29nFdc4GND8/df8K1jzGf8lj/0BNMrh85xeMZMrZq
	Ufl+DUpoinUwBTVlnIA/72/MJrM18OMPVit+j4RHTotK4U3LlzZgBt6PdWz+zmUNBc+J
	xHEzb5OdbmPTsYtc0REXLAbifpCegivMvjXxWnhvI0fGEnMqNlTXDygg2bWowVJhYX2B
	J/lYtm+a+HnIb2eHlY6xkx/pLZRk2APWvFNijiorQ3lh4XMansB9EMtv9IdIufz+AuRg
	8qbQ==
In-Reply-To: <20180303091913.GA13118@mail.hallyn.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: "Serge E. Hallyn" <serge@hallyn.com>, Richard Guy Briggs <rgb@redhat.com>
Cc: mszeredi@redhat.com, cgroups@vger.kernel.org, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com, Linux-Audit Mailing List <linux-audit@redhat.com>, ebiederm@xmission.com, simo@redhat.com, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, trondmy@primarydata.com, viro@zeniv.linux.org.uk

On Sat, Mar 3, 2018 at 4:19 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> On Thu, Mar 01, 2018 at 02:41:04PM -0500, Richard Guy Briggs wrote:
> ...
>> +static inline bool audit_containerid_set(struct task_struct *tsk)
>
> Hi Richard,
>
> the calls to audit_containerid_set() confused me.  Could you make it
> is_audit_containerid_set() or audit_containerid_isset()?

I haven't gone through the entire patchset yet, but I wanted to
quickly comment on this ... I really dislike the
function-names-as-sentences approach and would would greatly prefer
audit_containerid_isset().

>> +{
>> +     return audit_get_containerid(tsk) != INVALID_CID;
>> +}

-- 
paul moore
www.paul-moore.com
